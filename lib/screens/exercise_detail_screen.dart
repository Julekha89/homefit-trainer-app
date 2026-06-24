import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/workout.dart';
import '../services/voice_coach_service.dart';
import '../widgets/exercise_media_player.dart';
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
                  ExerciseMediaPlayer(
                    exercise: exercise,
                    gender: gender,
                    videoEnabled: false,
                  ),
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
