import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/health_models.dart';
import '../models/workout.dart';
import '../services/firebase_service.dart';
import '../services/firestore_service.dart';
import '../services/voice_coach_service.dart';
import '../widgets/exercise_media_player.dart';

class WorkoutTimerScreen extends StatefulWidget {
  const WorkoutTimerScreen({
    super.key,
    required this.exercise,
    required this.gender,
  });

  final Exercise exercise;
  final Gender gender;

  @override
  State<WorkoutTimerScreen> createState() => _WorkoutTimerScreenState();
}

class _WorkoutTimerScreenState extends State<WorkoutTimerScreen> {
  Timer? _timer;
  late int _remaining;
  bool _running = false;
  bool _voiceEnabled = true;
  bool _showVideo = false;

  @override
  void initState() {
    super.initState();
    _remaining = widget.exercise.durationSeconds;
    unawaited(VoiceCoachService.instance.initialize());
  }

  @override
  void dispose() {
    _timer?.cancel();
    unawaited(VoiceCoachService.instance.stop());
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_running) {
      _timer?.cancel();
      setState(() => _running = false);
      return;
    }
    if (_remaining == 0) _remaining = widget.exercise.durationSeconds;
    setState(() => _showVideo = true);
    if (_voiceEnabled) {
      await VoiceCoachService.instance.countdown();
      if (!mounted) return;
    }
    setState(() => _running = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining <= 1) {
        timer.cancel();
        setState(() {
          _remaining = 0;
          _running = false;
        });
        unawaited(_showComplete());
      } else {
        setState(() => _remaining--);
      }
    });
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _remaining = widget.exercise.durationSeconds;
      _running = false;
      _showVideo = false;
    });
  }

  Future<void> _showComplete() async {
    if (_voiceEnabled) {
      await VoiceCoachService.instance.speak(
        '${widget.exercise.name} complete. Great work.',
      );
    }
    final userId = FirebaseService.instance.isConfigured
        ? FirebaseAuth.instance.currentUser?.uid
        : null;
    if (userId != null) {
      await FirestoreService.instance.recordWorkout(
        userId,
        WorkoutHistoryEntry(
          exerciseName: widget.exercise.name,
          category: widget.exercise.category,
          durationSeconds: widget.exercise.durationSeconds,
          calories: widget.exercise.calories.toDouble(),
          completedAt: DateTime.now(),
        ),
      );
    }
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.emoji_events_rounded,
          color: AppColors.lime,
          size: 44,
        ),
        title: const Text('Exercise complete!'),
        content: Text(
          'Great work—you finished ${widget.exercise.name}.',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = 1 - (_remaining / widget.exercise.durationSeconds);
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          widget.exercise.name,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: ExerciseMediaPlayer(
                    exercise: widget.exercise,
                    gender: widget.gender,
                    videoEnabled: _showVideo,
                    autoPlay: _running,
                    showControls: false,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: 176,
                height: 176,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 12,
                        backgroundColor: const Color(0xFF253346),
                        color: _remaining == 0
                            ? AppColors.lime
                            : AppColors.cyan,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$_remaining',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 56,
                            height: 1,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'SECONDS',
                          style: TextStyle(
                            color: Color(0xFF94A7B8),
                            letterSpacing: 2,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                value: _voiceEnabled,
                onChanged: (value) => setState(() => _voiceEnabled = value),
                title: const Text(
                  'Voice Coach',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                subtitle: const Text(
                  'Countdowns and encouragement',
                  style: TextStyle(color: Color(0xFF94A7B8)),
                ),
                secondary: const Icon(
                  Icons.record_voice_over_rounded,
                  color: AppColors.cyan,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filledTonal(
                    onPressed: _reset,
                    icon: const Icon(Icons.replay_rounded),
                    iconSize: 30,
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.lime,
                        foregroundColor: AppColors.navy,
                      ),
                      onPressed: () => unawaited(_toggle()),
                      icon: Icon(
                        _running
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                      ),
                      iconSize: 40,
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton.filledTonal(
                    onPressed: () => unawaited(_showComplete()),
                    icon: const Icon(Icons.skip_next_rounded),
                    iconSize: 30,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
