import 'package:flutter/material.dart';

enum Gender { female, male }

extension GenderX on Gender {
  String get label => this == Gender.female ? 'Female' : 'Male';

  String get asset => this == Gender.female
      ? 'assets/exercises/female/female.png'
      : 'assets/exercises/male/male.png';

  Color get color =>
      this == Gender.female ? const Color(0xFFFF3C8D) : const Color(0xFF1688FF);
}

enum FitnessGoal { loseWeight, buildMuscle, stayFit }

extension FitnessGoalX on FitnessGoal {
  String get label => switch (this) {
    FitnessGoal.loseWeight => 'Lose weight',
    FitnessGoal.buildMuscle => 'Build muscle',
    FitnessGoal.stayFit => 'Stay fit',
  };

  String get description => switch (this) {
    FitnessGoal.loseWeight => 'Burn calories and improve endurance',
    FitnessGoal.buildMuscle => 'Develop strength and lean muscle',
    FitnessGoal.stayFit => 'Maintain an active, balanced lifestyle',
  };

  IconData get icon => switch (this) {
    FitnessGoal.loseWeight => Icons.local_fire_department_rounded,
    FitnessGoal.buildMuscle => Icons.fitness_center_rounded,
    FitnessGoal.stayFit => Icons.favorite_rounded,
  };
}

enum FitnessLevel { beginner, intermediate, advanced }

extension FitnessLevelX on FitnessLevel {
  String get label => switch (this) {
    FitnessLevel.beginner => 'Beginner',
    FitnessLevel.intermediate => 'Intermediate',
    FitnessLevel.advanced => 'Advanced',
  };

  String get description => switch (this) {
    FitnessLevel.beginner => 'Short sessions with generous recovery',
    FitnessLevel.intermediate => 'Balanced intensity and steady progression',
    FitnessLevel.advanced => 'High-intensity sessions and bigger challenges',
  };

  int get rounds => switch (this) {
    FitnessLevel.beginner => 2,
    FitnessLevel.intermediate => 3,
    FitnessLevel.advanced => 4,
  };
}

class Exercise {
  const Exercise({
    required this.name,
    required this.category,
    required this.durationSeconds,
    required this.calories,
    required this.instructions,
    required this.muscles,
  });

  final String name;
  final String category;
  final int durationSeconds;
  final int calories;
  final List<String> instructions;
  final List<String> muscles;
}

class WorkoutCategory {
  const WorkoutCategory({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.exercises,
  });

  final String name;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<Exercise> exercises;
}
