import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/health_models.dart';
import '../services/firebase_service.dart';
import '../services/firestore_service.dart';

class WorkoutHistoryScreen extends StatelessWidget {
  const WorkoutHistoryScreen({super.key});

  String get _userId => FirebaseService.instance.isConfigured
      ? FirebaseAuth.instance.currentUser?.uid ?? 'demo-user'
      : 'demo-user';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout History')),
      body: StreamBuilder<List<WorkoutHistoryEntry>>(
        stream: FirestoreService.instance.watchWorkoutHistory(_userId),
        builder: (context, snapshot) {
          final workouts = snapshot.data ?? const <WorkoutHistoryEntry>[];
          if (workouts.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.history_rounded,
                      color: AppColors.cyan,
                      size: 56,
                    ),
                    SizedBox(height: 14),
                    Text(
                      'No synced workouts yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Complete an exercise after connecting Firebase to build your history.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: workouts.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0x1A00C8E8),
                    child: Icon(Icons.check_rounded, color: AppColors.cyan),
                  ),
                  title: Text(
                    workout.exerciseName,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  subtitle: Text(
                    '${workout.category} • ${workout.durationSeconds}s • ${workout.calories.round()} kcal',
                  ),
                  trailing: Text(
                    '${workout.completedAt.day}/${workout.completedAt.month}',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
