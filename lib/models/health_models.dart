import 'package:cloud_firestore/cloud_firestore.dart';

import 'workout.dart';

class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    required this.displayName,
    required this.gender,
    required this.goal,
    required this.level,
    this.heightCm = 170,
    this.currentWeightKg = 70,
    this.dailyStreak = 0,
  });

  final String id;
  final String email;
  final String displayName;
  final Gender gender;
  final FitnessGoal goal;
  final FitnessLevel level;
  final double heightCm;
  final double currentWeightKg;
  final int dailyStreak;

  Map<String, Object?> toMap() => {
    'email': email,
    'displayName': displayName,
    'gender': gender.name,
    'goal': goal.name,
    'level': level.name,
    'heightCm': heightCm,
    'currentWeightKg': currentWeightKg,
    'dailyStreak': dailyStreak,
    'updatedAt': FieldValue.serverTimestamp(),
  };

  factory UserProfile.fromMap(String id, Map<String, Object?> data) {
    return UserProfile(
      id: id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? 'HomeFit Athlete',
      gender: Gender.values.byName(data['gender'] as String? ?? 'female'),
      goal: FitnessGoal.values.byName(data['goal'] as String? ?? 'stayFit'),
      level: FitnessLevel.values.byName(data['level'] as String? ?? 'beginner'),
      heightCm: (data['heightCm'] as num?)?.toDouble() ?? 170,
      currentWeightKg: (data['currentWeightKg'] as num?)?.toDouble() ?? 70,
      dailyStreak: (data['dailyStreak'] as num?)?.toInt() ?? 0,
    );
  }
}

class WeightEntry {
  const WeightEntry({required this.weightKg, required this.recordedAt});

  final double weightKg;
  final DateTime recordedAt;

  Map<String, Object?> toMap() => {
    'weightKg': weightKg,
    'recordedAt': Timestamp.fromDate(recordedAt),
  };

  factory WeightEntry.fromMap(Map<String, Object?> data) {
    return WeightEntry(
      weightKg: (data['weightKg'] as num).toDouble(),
      recordedAt: (data['recordedAt'] as Timestamp).toDate(),
    );
  }
}

class WorkoutHistoryEntry {
  const WorkoutHistoryEntry({
    required this.exerciseName,
    required this.category,
    required this.durationSeconds,
    required this.calories,
    required this.completedAt,
  });

  final String exerciseName;
  final String category;
  final int durationSeconds;
  final double calories;
  final DateTime completedAt;

  Map<String, Object?> toMap() => {
    'exerciseName': exerciseName,
    'category': category,
    'durationSeconds': durationSeconds,
    'calories': calories,
    'completedAt': Timestamp.fromDate(completedAt),
  };

  factory WorkoutHistoryEntry.fromMap(Map<String, Object?> data) {
    return WorkoutHistoryEntry(
      exerciseName: data['exerciseName'] as String,
      category: data['category'] as String,
      durationSeconds: (data['durationSeconds'] as num).toInt(),
      calories: (data['calories'] as num).toDouble(),
      completedAt: (data['completedAt'] as Timestamp).toDate(),
    );
  }
}
