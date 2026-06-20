import 'package:flutter/material.dart';

import '../models/workout.dart';

const _standardSteps = <String>[
  'Start in a stable position and brace your core.',
  'Move with control while keeping your breathing steady.',
  'Return to the starting position and repeat with good form.',
];

Exercise _exercise(
  String name,
  String category,
  int seconds,
  int calories,
  List<String> muscles,
) {
  return Exercise(
    name: name,
    category: category,
    durationSeconds: seconds,
    calories: calories,
    instructions: _standardSteps,
    muscles: muscles,
  );
}

final workoutCategories = <WorkoutCategory>[
  WorkoutCategory(
    name: 'Core Power',
    subtitle: 'Strengthen abs and stability',
    icon: Icons.blur_circular_rounded,
    color: const Color(0xFF00B8D9),
    exercises: [
      _exercise('Plank', 'Core Power', 30, 6, ['Core', 'Shoulders']),
      _exercise('Standard Crunch', 'Core Power', 40, 8, ['Upper abs']),
      _exercise('Bicycle Crunch', 'Core Power', 40, 10, ['Core', 'Obliques']),
      _exercise('Russian Twists', 'Core Power', 45, 11, ['Obliques']),
      _exercise('Mountain Climbers', 'Core Power', 35, 12, ['Core', 'Cardio']),
    ],
  ),
  WorkoutCategory(
    name: 'Upper Body',
    subtitle: 'Chest, arms, shoulders and back',
    icon: Icons.fitness_center_rounded,
    color: const Color(0xFF7A5AF8),
    exercises: [
      _exercise('Classic Pushups', 'Upper Body', 40, 10, ['Chest', 'Triceps']),
      _exercise('Diamond Pushups', 'Upper Body', 35, 11, ['Triceps', 'Chest']),
      _exercise('Chair Dips', 'Upper Body', 40, 9, ['Triceps', 'Shoulders']),
      _exercise('Arm Circles', 'Upper Body', 45, 6, ['Shoulders']),
      _exercise('Superman', 'Upper Body', 35, 7, ['Back', 'Glutes']),
    ],
  ),
  WorkoutCategory(
    name: 'Lower Body',
    subtitle: 'Legs, thighs and glutes',
    icon: Icons.directions_run_rounded,
    color: const Color(0xFFFF8A34),
    exercises: [
      _exercise('Standard Squats', 'Lower Body', 45, 12, ['Quads', 'Glutes']),
      _exercise('Reverse Lunges', 'Lower Body', 45, 13, ['Legs', 'Glutes']),
      _exercise('Curtsy Lunges', 'Lower Body', 40, 11, ['Glutes', 'Thighs']),
      _exercise('Calf Raises', 'Lower Body', 45, 8, ['Calves']),
      _exercise('Glute Bridge', 'Lower Body', 40, 9, ['Glutes', 'Hamstrings']),
    ],
  ),
  WorkoutCategory(
    name: 'Full Body',
    subtitle: 'Efficient head-to-toe training',
    icon: Icons.bolt_rounded,
    color: const Color(0xFF93D500),
    exercises: [
      _exercise('Burpees', 'Full Body', 35, 15, ['Full body', 'Cardio']),
      _exercise('Mountain Climbers', 'Full Body', 40, 14, ['Core', 'Cardio']),
      _exercise('Standard Squats', 'Full Body', 45, 12, ['Legs', 'Glutes']),
      _exercise('Reverse Lunges', 'Full Body', 45, 13, ['Legs', 'Balance']),
      _exercise('Classic Pushups', 'Full Body', 40, 10, ['Chest', 'Arms']),
    ],
  ),
  WorkoutCategory(
    name: 'Mobility',
    subtitle: 'Recover, stretch and move better',
    icon: Icons.self_improvement_rounded,
    color: const Color(0xFFFF3C8D),
    exercises: [
      _exercise('Cobra Stretch', 'Mobility', 30, 3, ['Core', 'Back']),
      _exercise('Side Leg Raises', 'Mobility', 40, 6, ['Hips', 'Glutes']),
      _exercise('Prone Y-Lifts', 'Mobility', 35, 5, ['Back', 'Shoulders']),
      _exercise('Fire Hydrants', 'Mobility', 40, 7, ['Hips', 'Glutes']),
      _exercise('Arm Circles', 'Mobility', 40, 4, ['Shoulders']),
    ],
  ),
];
