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
    this.femaleImageAsset,
    this.femaleVideoAsset,
    this.maleImageAsset,
    this.maleVideoAsset,
  });

  final String name;
  final String category;
  final int durationSeconds;
  final int calories;
  final List<String> instructions;
  final List<String> muscles;
  final String? femaleImageAsset;
  final String? femaleVideoAsset;
  final String? maleImageAsset;
  final String? maleVideoAsset;
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

enum CourseLength { thirtyDays, ninetyDays }

extension CourseLengthX on CourseLength {
  String get label => switch (this) {
    CourseLength.thirtyDays => '30-Day',
    CourseLength.ninetyDays => '90-Day',
  };

  int get days => switch (this) {
    CourseLength.thirtyDays => 30,
    CourseLength.ninetyDays => 90,
  };

  String get productName => switch (this) {
    CourseLength.thirtyDays => 'Starter Plan',
    CourseLength.ninetyDays => 'Transformation Plan',
  };
}

class CoursePhase {
  const CoursePhase({required this.title, required this.description});

  final String title;
  final String description;
}

class CourseWeek {
  const CourseWeek({required this.title, required this.days});

  final String title;
  final List<String> days;
}

class CoursePlan {
  const CoursePlan({
    required this.id,
    required this.gender,
    required this.goal,
    required this.level,
    required this.length,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.workoutDaysPerWeek,
    required this.minutesPerDay,
    required this.phases,
    required this.weeklySchedule,
  });

  final String id;
  final Gender gender;
  final FitnessGoal goal;
  final FitnessLevel level;
  final CourseLength length;
  final String title;
  final String subtitle;
  final String description;
  final int workoutDaysPerWeek;
  final String minutesPerDay;
  final List<CoursePhase> phases;
  final List<CourseWeek> weeklySchedule;
}
