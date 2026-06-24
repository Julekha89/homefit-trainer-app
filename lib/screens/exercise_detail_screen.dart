import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../core/app_theme.dart';
import '../models/workout.dart';
import '../services/voice_coach_service.dart';
import 'workout_timer_screen.dart';

class ExerciseDetailScreen extends StatelessWidget {
  const ExerciseDetailScreen({
    super.key,
    required this.exercise,
    required this.gender,
    required this.level,
  });

  final Exercise exercise;
  final Gender gender;
  final FitnessLevel level;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            expandedHeight: 390,
            pinned: true,
            backgroundColor: AppColors.navy,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                exercise.name,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  ExerciseMediaPlayer(exercise: exercise, gender: gender),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xCC08111F)],
                        stops: [0.45, 1],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
            sliver: SliverList.list(
              children: [
                Row(
                  children: [
                    _InfoChip(
                      icon: Icons.timer_outlined,
                      text: '${exercise.durationSeconds} sec',
                    ),
                    const SizedBox(width: 10),
                    _InfoChip(
                      icon: Icons.local_fire_department_outlined,
                      text: '${exercise.calories} kcal',
                    ),
                    const SizedBox(width: 10),
                    _InfoChip(
                      icon: Icons.signal_cellular_alt_rounded,
                      text: level.label,
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  'How to perform',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 14),
                ...exercise.instructions.indexed.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.navy,
                          child: Text(
                            '${entry.$1 + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              entry.$2,
                              style: const TextStyle(height: 1.4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Target muscles',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: exercise.muscles
                      .map(
                        (muscle) => Chip(
                          avatar: const Icon(
                            Icons.check_circle_rounded,
                            size: 18,
                            color: AppColors.cyan,
                          ),
                          label: Text(muscle),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  onPressed: () async {
                    await VoiceCoachService.instance.initialize();
                    await VoiceCoachService.instance.announceExercise(exercise);
                  },
                  icon: const Icon(Icons.volume_up_rounded),
                  label: const Text('Hear exercise instructions'),
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => WorkoutTimerScreen(
                        exercise: exercise,
                        gender: gender,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Start exercise'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExerciseMediaPlayer extends StatefulWidget {
  const ExerciseMediaPlayer({
    super.key,
    required this.exercise,
    required this.gender,
  });

  final Exercise exercise;
  final Gender gender;

  @override
  State<ExerciseMediaPlayer> createState() => _ExerciseMediaPlayerState();
}

class _ExerciseMediaPlayerState extends State<ExerciseMediaPlayer> {
  VideoPlayerController? _controller;
  Future<void>? _initialize;
  bool _failed = false;

  bool get _shouldUseVideo =>
      widget.gender == Gender.female &&
      widget.exercise.videoAsset != null &&
      widget.exercise.videoAsset!.isNotEmpty;

  String get _fallbackAsset =>
      widget.gender == Gender.female &&
          widget.exercise.imageAsset != null &&
          widget.exercise.imageAsset!.isNotEmpty
      ? widget.exercise.imageAsset!
      : widget.gender.asset;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  @override
  void didUpdateWidget(covariant ExerciseMediaPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.videoAsset != widget.exercise.videoAsset ||
        oldWidget.gender != widget.gender) {
      unawaited(_controller?.dispose());
      _controller = null;
      _initialize = null;
      _failed = false;
      _loadVideo();
    }
  }

  @override
  void dispose() {
    unawaited(_controller?.dispose());
    super.dispose();
  }

  void _loadVideo() {
    if (!_shouldUseVideo) return;

    final controller = VideoPlayerController.asset(widget.exercise.videoAsset!);
    _controller = controller;
    _initialize = controller
        .initialize()
        .then((_) {
          controller.setLooping(true);
          if (mounted) setState(() {});
        })
        .catchError((Object _) {
          if (mounted) setState(() => _failed = true);
        });
  }

  Future<void> _toggle() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (controller.value.isPlaying) {
      await controller.pause();
    } else {
      await controller.play();
    }
    if (mounted) setState(() {});
  }

  Future<void> _replay() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    await controller.seekTo(Duration.zero);
    await controller.play();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldUseVideo || _failed) return _fallbackImage();

    final initialize = _initialize;
    final controller = _controller;
    if (initialize == null || controller == null) return _fallbackImage();

    return FutureBuilder<void>(
      future: initialize,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            !controller.value.isInitialized) {
          return Stack(
            fit: StackFit.expand,
            children: [
              _fallbackImage(),
              const Center(child: CircularProgressIndicator()),
            ],
          );
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: VideoPlayer(controller),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 72,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filledTonal(
                    onPressed: () => unawaited(_replay()),
                    icon: const Icon(Icons.replay_rounded),
                    tooltip: 'Replay video',
                  ),
                  const SizedBox(width: 12),
                  IconButton.filled(
                    onPressed: () => unawaited(_toggle()),
                    icon: Icon(
                      controller.value.isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                    ),
                    tooltip: controller.value.isPlaying
                        ? 'Pause video'
                        : 'Play video',
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _fallbackImage() {
    return Image.asset(
      _fallbackAsset,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      errorBuilder: (_, _, _) => Image.asset(
        widget.gender.asset,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.cyan),
            const SizedBox(height: 6),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
