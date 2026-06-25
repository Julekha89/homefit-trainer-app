import 'package:flutter/material.dart';

import '../models/workout.dart';

const _femaleRoot = 'assets/exercises/female/Girl';
const _femaleVideoRoot = 'assets/exercises/female/videos';
const _maleRoot = 'assets/exercises/male/Boy';
const _maleVideoRoot = 'assets/exercises/male/videos';

const _standardSteps = <String>[
  'Start in a stable position and brace your core.',
  'Move with control while keeping your breathing steady.',
  'Return to the starting position and repeat with good form.',
];

String? exerciseImageAssetFor(Exercise exercise, Gender gender) {
  return switch (gender) {
    Gender.female => exercise.femaleImageAsset,
    Gender.male => exercise.maleImageAsset,
  };
}

String? exerciseVideoAssetFor(Exercise exercise, Gender gender) {
  return switch (gender) {
    Gender.female => exercise.femaleVideoAsset,
    Gender.male => exercise.maleVideoAsset,
  };
}

Exercise _exercise(
  String name,
  String category,
  int seconds,
  int calories,
  List<String> muscles, {
  String? femaleImageAsset,
  String? femaleVideoAsset,
  String? maleImageAsset,
  String? maleVideoAsset,
}) {
  return Exercise(
    name: name,
    category: category,
    durationSeconds: seconds,
    calories: calories,
    instructions: _standardSteps,
    muscles: muscles,
    femaleImageAsset: femaleImageAsset,
    femaleVideoAsset: femaleVideoAsset,
    maleImageAsset: maleImageAsset,
    maleVideoAsset: maleVideoAsset,
  );
}

final workoutCategories = <WorkoutCategory>[
  WorkoutCategory(
    name: 'Core Power',
    subtitle: 'Strengthen abs and stability',
    icon: Icons.blur_circular_rounded,
    color: const Color(0xFF00B8D9),
    exercises: [
      _exercise(
        'Plank',
        'Core Power',
        30,
        6,
        ['Core', 'Shoulders'],
        femaleImageAsset: '$_femaleRoot/Belly slimming/Plank.png',
        femaleVideoAsset: '$_femaleVideoRoot/plank.mp4',
        maleImageAsset: '$_maleRoot/Six-Pack ABS/Plank.png',
        maleVideoAsset: '$_maleVideoRoot/plank.mp4',
      ),
      _exercise(
        'Standard Crunch',
        'Core Power',
        40,
        8,
        ['Upper abs'],
        femaleImageAsset: '$_femaleRoot/Belly slimming/Stander Crunch.png',
        femaleVideoAsset: '$_femaleVideoRoot/standard_crunch.mp4',
        maleImageAsset: '$_maleRoot/Six-Pack ABS/stander crunch.png',
        maleVideoAsset: '$_maleVideoRoot/standard_crunch.mp4',
      ),
      _exercise(
        'Bicycle Crunch',
        'Core Power',
        40,
        10,
        ['Core', 'Obliques'],
        femaleImageAsset: '$_femaleRoot/Belly slimming/Bicycle Crunch.png',
        femaleVideoAsset: '$_femaleVideoRoot/bicycle_crunch.mp4',
        maleImageAsset: '$_maleRoot/Six-Pack ABS/bicycle crunch.png',
        maleVideoAsset: '$_maleVideoRoot/bicycle_crunch.mp4',
      ),
      _exercise(
        'Russian Twists',
        'Core Power',
        45,
        11,
        ['Obliques'],
        femaleImageAsset: '$_femaleRoot/Belly slimming/Russian Twists.png',
        femaleVideoAsset: '$_femaleVideoRoot/russian_twists.mp4',
        maleImageAsset: '$_maleRoot/Six-Pack ABS/Russian twist.png',
        maleVideoAsset: '$_maleVideoRoot/russian_twists.mp4',
      ),
      _exercise(
        'Mountain Climbers',
        'Core Power',
        35,
        12,
        ['Core', 'Cardio'],
        femaleImageAsset: '$_femaleRoot/full body fitness/Mountain Climber.png',
        femaleVideoAsset: '$_femaleVideoRoot/mountain_climbers.mp4',
        maleImageAsset: '$_maleRoot/Six-Pack ABS/mountain climber.png',
        maleVideoAsset: '$_maleVideoRoot/mountain_climbers.mp4',
      ),
    ],
  ),
  WorkoutCategory(
    name: 'Upper Body',
    subtitle: 'Chest, arms, shoulders and back',
    icon: Icons.fitness_center_rounded,
    color: const Color(0xFF7A5AF8),
    exercises: [
      _exercise(
        'Classic Pushups',
        'Upper Body',
        40,
        10,
        ['Chest', 'Triceps'],
        femaleImageAsset: '$_femaleRoot/Tone arms & bust/Claasic Pushups.png',
        femaleVideoAsset: '$_femaleVideoRoot/classic_pushups.mp4',
        maleImageAsset: '$_maleRoot/Chest & Arms Build/Classic Pushups.png',
        maleVideoAsset: '$_maleVideoRoot/classic_pushups.mp4',
      ),
      _exercise(
        'Diamond Pushups',
        'Upper Body',
        35,
        11,
        ['Triceps', 'Chest'],
        maleImageAsset: '$_maleRoot/Chest & Arms Build/diamond Pushups.png',
        maleVideoAsset: '$_maleVideoRoot/diamond_pushups.mp4',
      ),
      _exercise(
        'Chair Dips',
        'Upper Body',
        40,
        9,
        ['Triceps', 'Shoulders'],
        femaleImageAsset: '$_femaleRoot/Tone arms & bust/Chair Dips.png',
        femaleVideoAsset: '$_femaleVideoRoot/chair_dips.mp4',
        maleImageAsset: '$_maleRoot/Chest & Arms Build/chair dips.png',
        maleVideoAsset: '$_maleVideoRoot/chair_dips.mp4',
      ),
      _exercise(
        'Arm Circles',
        'Upper Body',
        45,
        6,
        ['Shoulders'],
        femaleImageAsset: '$_femaleRoot/Tone arms & bust/Arm Circle (2).png',
        femaleVideoAsset: '$_femaleVideoRoot/arm_circles.mp4',
        maleImageAsset: '$_maleRoot/Shoulder & Back Power/arm circles.png',
        maleVideoAsset: '$_maleVideoRoot/arm_circles.mp4',
      ),
      _exercise(
        'Superman',
        'Upper Body',
        35,
        7,
        ['Back', 'Glutes'],
        maleImageAsset: '$_maleRoot/Shoulder & Back Power/superman.png',
        maleVideoAsset: '$_maleVideoRoot/superman.mp4',
      ),
    ],
  ),
  WorkoutCategory(
    name: 'Lower Body',
    subtitle: 'Legs, thighs and glutes',
    icon: Icons.directions_run_rounded,
    color: const Color(0xFFFF8A34),
    exercises: [
      _exercise(
        'Standard Squats',
        'Lower Body',
        45,
        12,
        ['Quads', 'Glutes'],
        femaleImageAsset:
            '$_femaleRoot/Slender legs & thighs/Stander Squatas.png',
        femaleVideoAsset: '$_femaleVideoRoot/standard_squats.mp4',
        maleImageAsset: '$_maleRoot/Legs & Thighs/Standard squat.png',
        maleVideoAsset: '$_maleVideoRoot/standard_squats.mp4',
      ),
      _exercise(
        'Reverse Lunges',
        'Lower Body',
        45,
        13,
        ['Legs', 'Glutes'],
        femaleImageAsset:
            '$_femaleRoot/Slender legs & thighs/Reserve Lunges.png',
        femaleVideoAsset: '$_femaleVideoRoot/reverse_lunges.mp4',
        maleImageAsset: '$_maleRoot/Legs & Thighs/reverse lunges.png',
        maleVideoAsset: '$_maleVideoRoot/reverse_lunges.mp4',
      ),
      _exercise(
        'Curtsy Lunges',
        'Lower Body',
        40,
        11,
        ['Glutes', 'Thighs'],
        femaleImageAsset:
            '$_femaleRoot/Slender legs & thighs/Curtsy Lunges.png',
        femaleVideoAsset: '$_femaleVideoRoot/curtsy_lunges.mp4',
        maleImageAsset: '$_maleRoot/Legs & Thighs/cursty lunges.png',
        maleVideoAsset: '$_maleVideoRoot/curtsy_lunges.mp4',
      ),
      _exercise(
        'Calf Raises',
        'Lower Body',
        45,
        8,
        ['Calves'],
        femaleImageAsset: '$_femaleRoot/Slender legs & thighs/calf raises.png',
        femaleVideoAsset: '$_femaleVideoRoot/calf_raises.mp4',
        maleImageAsset: '$_maleRoot/Legs & Thighs/Calf raises.png',
      ),
      _exercise(
        'Glute Bridge',
        'Lower Body',
        40,
        9,
        ['Glutes', 'Hamstrings'],
        femaleImageAsset:
            '$_femaleRoot/Gulutes & Butt Sculpt/glute-bridges.png',
        femaleVideoAsset: '$_femaleVideoRoot/glute_bridge.mp4',
      ),
    ],
  ),
  WorkoutCategory(
    name: 'Full Body',
    subtitle: 'Efficient head-to-toe training',
    icon: Icons.bolt_rounded,
    color: const Color(0xFF93D500),
    exercises: [
      _exercise(
        'Burpees',
        'Full Body',
        35,
        15,
        ['Full body', 'Cardio'],
        femaleImageAsset: '$_femaleRoot/full body fitness/Burpees.png',
        femaleVideoAsset: '$_femaleVideoRoot/burpees.mp4',
        maleImageAsset: '$_maleRoot/Full body Fitness/burpees.png',
        maleVideoAsset: '$_maleVideoRoot/burpees.mp4',
      ),
      _exercise(
        'Mountain Climbers',
        'Full Body',
        40,
        14,
        ['Core', 'Cardio'],
        femaleImageAsset: '$_femaleRoot/full body fitness/Mountain Climber.png',
        femaleVideoAsset: '$_femaleVideoRoot/mountain_climbers.mp4',
        maleImageAsset: '$_maleRoot/Full body Fitness/mountain climber.png',
        maleVideoAsset: '$_maleVideoRoot/full_body_mountain_climbers.mp4',
      ),
      _exercise(
        'Standard Squats',
        'Full Body',
        45,
        12,
        ['Legs', 'Glutes'],
        femaleImageAsset: '$_femaleRoot/full body fitness/Stander Squatas.png',
        femaleVideoAsset: '$_femaleVideoRoot/full_body_standard_squats.mp4',
        maleImageAsset: '$_maleRoot/Full body Fitness/Standard squat.png',
        maleVideoAsset: '$_maleVideoRoot/full_body_standard_squats.mp4',
      ),
      _exercise(
        'Reverse Lunges',
        'Full Body',
        45,
        13,
        ['Legs', 'Balance'],
        femaleImageAsset: '$_femaleRoot/full body fitness/Reverse Lunges.png',
        femaleVideoAsset: '$_femaleVideoRoot/full_body_reverse_lunges.mp4',
        maleImageAsset: '$_maleRoot/Full body Fitness/reverse lunges.png',
        maleVideoAsset: '$_maleVideoRoot/full_body_reverse_lunges.mp4',
      ),
      _exercise(
        'Classic Pushups',
        'Full Body',
        40,
        10,
        ['Chest', 'Arms'],
        femaleImageAsset: '$_femaleRoot/full body fitness/Classsic Pushups.png',
        femaleVideoAsset: '$_femaleVideoRoot/full_body_classic_pushups.mp4',
        maleImageAsset: '$_maleRoot/Full body Fitness/Classic Pushups.png',
        maleVideoAsset: '$_maleVideoRoot/full_body_classic_pushups.mp4',
      ),
    ],
  ),
  WorkoutCategory(
    name: 'Mobility',
    subtitle: 'Recover, stretch and move better',
    icon: Icons.self_improvement_rounded,
    color: const Color(0xFFFF3C8D),
    exercises: [
      _exercise(
        'Cobra Stretch',
        'Mobility',
        30,
        3,
        ['Core', 'Back'],
        femaleImageAsset: '$_femaleRoot/Tone arms & bust/Cobra Switch.png',
        femaleVideoAsset: '$_femaleVideoRoot/cobra_stretch.mp4',
      ),
      _exercise(
        'Side Leg Raises',
        'Mobility',
        40,
        6,
        ['Hips', 'Glutes'],
        femaleImageAsset:
            '$_femaleRoot/Slender legs & thighs/Side Leg Raises.png',
        femaleVideoAsset: '$_femaleVideoRoot/side_leg_raises.mp4',
      ),
      _exercise(
        'Prone Y-Lifts',
        'Mobility',
        35,
        5,
        ['Back', 'Shoulders'],
        maleImageAsset: '$_maleRoot/Shoulder & Back Power/Prone Y-lift.png',
        maleVideoAsset: '$_maleVideoRoot/prone_y_lift.mp4',
      ),
      _exercise(
        'Fire Hydrants',
        'Mobility',
        40,
        7,
        ['Hips', 'Glutes'],
        femaleImageAsset:
            '$_femaleRoot/Gulutes & Butt Sculpt/Fire hydrates.png',
        femaleVideoAsset: '$_femaleVideoRoot/fire_hydrants.mp4',
      ),
      _exercise(
        'Arm Circles',
        'Mobility',
        40,
        4,
        ['Shoulders'],
        femaleImageAsset: '$_femaleRoot/Tone arms & bust/Arm Circle (2).png',
        femaleVideoAsset: '$_femaleVideoRoot/arm_circles.mp4',
        maleImageAsset: '$_maleRoot/Shoulder & Back Power/arm circles.png',
        maleVideoAsset: '$_maleVideoRoot/arm_circles.mp4',
      ),
    ],
  ),
];
