import 'package:flutter/material.dart';

import '../models/workout.dart';

const _femaleGirlRoot = 'assets/exercises/female/Girl';
const _femaleVideoRoot = 'assets/exercises/female/videos';

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
  String imageAsset,
  String videoAsset,
) {
  return Exercise(
    name: name,
    category: category,
    durationSeconds: seconds,
    calories: calories,
    instructions: _standardSteps,
    muscles: muscles,
    imageAsset: imageAsset,
    videoAsset: videoAsset,
  );
}

final workoutCategories = <WorkoutCategory>[
  WorkoutCategory(
    name: 'Belly Slimming',
    subtitle: 'Strengthen abs and tighten your waistline',
    icon: Icons.blur_circular_rounded,
    color: const Color(0xFF00B8D9),
    exercises: [
      _exercise(
        'Plank',
        'Belly Slimming',
        30,
        6,
        ['Core', 'Shoulders'],
        '$_femaleGirlRoot/Belly slimming/Plank.png',
        'assets/exercises/female/videos/plank.mp4',
      ),
      _exercise(
        'Standard Crunch',
        'Belly Slimming',
        40,
        8,
        ['Upper abs'],
        '$_femaleGirlRoot/Belly slimming/Stander Crunch.png',
        '$_femaleVideoRoot/standard_crunch.mp4',
      ),
      _exercise(
        'Bicycle Crunch',
        'Belly Slimming',
        40,
        10,
        ['Core', 'Obliques'],
        '$_femaleGirlRoot/Belly slimming/Bicycle Crunch.png',
        '$_femaleVideoRoot/bicycle_crunch.mp4',
      ),
      _exercise(
        'Flutter Kicks',
        'Belly Slimming',
        35,
        9,
        ['Lower abs', 'Hip flexors'],
        '$_femaleGirlRoot/Belly slimming/Flutter Kicks.png',
        '$_femaleVideoRoot/flutter_kicks.mp4',
      ),
      _exercise(
        'Russian Twists',
        'Belly Slimming',
        45,
        11,
        ['Obliques'],
        '$_femaleGirlRoot/Belly slimming/Russian Twists.png',
        '$_femaleVideoRoot/russian_twists.mp4',
      ),
    ],
  ),
  WorkoutCategory(
    name: 'Glutes & Butt Sculpt',
    subtitle: 'Shape glutes and build lower-body strength',
    icon: Icons.accessibility_new_rounded,
    color: const Color(0xFF7A5AF8),
    exercises: [
      _exercise(
        'Glute Bridge',
        'Glutes & Butt Sculpt',
        40,
        9,
        ['Glutes', 'Hamstrings'],
        '$_femaleGirlRoot/Gulutes & Butt Sculpt/glute-bridges.png',
        '$_femaleVideoRoot/glute_bridge.mp4',
      ),
      _exercise(
        'Donkey Kicks',
        'Glutes & Butt Sculpt',
        40,
        8,
        ['Glutes', 'Core'],
        '$_femaleGirlRoot/Gulutes & Butt Sculpt/donkey kicks.png',
        '$_femaleVideoRoot/donkey_kicks.mp4',
      ),
      _exercise(
        'Fire Hydrants',
        'Glutes & Butt Sculpt',
        40,
        7,
        ['Hips', 'Glutes'],
        '$_femaleGirlRoot/Gulutes & Butt Sculpt/Fire hydrates.png',
        '$_femaleVideoRoot/fire_hydrants.mp4',
      ),
      _exercise(
        'Sumo Squats',
        'Glutes & Butt Sculpt',
        45,
        12,
        ['Glutes', 'Inner thighs'],
        '$_femaleGirlRoot/Gulutes & Butt Sculpt/Sumo Squats.png',
        '$_femaleVideoRoot/sumo_squats.mp4',
      ),
    ],
  ),
  WorkoutCategory(
    name: 'Slender Legs & Thighs',
    subtitle: 'Tone legs, thighs, calves and balance',
    icon: Icons.directions_run_rounded,
    color: const Color(0xFFFF8A34),
    exercises: [
      _exercise(
        'Standard Squats',
        'Slender Legs & Thighs',
        45,
        12,
        ['Quads', 'Glutes'],
        '$_femaleGirlRoot/Slender legs & thighs/Stander Squatas.png',
        '$_femaleVideoRoot/standard_squats.mp4',
      ),
      _exercise(
        'Reverse Lunges',
        'Slender Legs & Thighs',
        45,
        13,
        ['Legs', 'Glutes'],
        '$_femaleGirlRoot/Slender legs & thighs/Reserve Lunges.png',
        '$_femaleVideoRoot/reverse_lunges.mp4',
      ),
      _exercise(
        'Side Leg Raises',
        'Slender Legs & Thighs',
        40,
        6,
        ['Hips', 'Glutes'],
        '$_femaleGirlRoot/Slender legs & thighs/Side Leg Raises.png',
        '$_femaleVideoRoot/side_leg_raises.mp4',
      ),
      _exercise(
        'Curtsy Lunges',
        'Slender Legs & Thighs',
        40,
        11,
        ['Glutes', 'Thighs'],
        '$_femaleGirlRoot/Slender legs & thighs/Curtsy Lunges.png',
        '$_femaleVideoRoot/curtsy_lunges.mp4',
      ),
      _exercise(
        'Calf Raises',
        'Slender Legs & Thighs',
        45,
        8,
        ['Calves'],
        '$_femaleGirlRoot/Slender legs & thighs/calf raises.png',
        '$_femaleVideoRoot/calf_raises.mp4',
      ),
    ],
  ),
  WorkoutCategory(
    name: 'Tone Arms & Bust',
    subtitle: 'Tone chest, arms, shoulders and posture',
    icon: Icons.fitness_center_rounded,
    color: const Color(0xFFFF3C8D),
    exercises: [
      _exercise(
        'Classic Pushups',
        'Tone Arms & Bust',
        40,
        10,
        ['Chest', 'Triceps'],
        '$_femaleGirlRoot/Tone arms & bust/Claasic Pushups.png',
        '$_femaleVideoRoot/classic_pushups.mp4',
      ),
      _exercise(
        'Knee Pushups',
        'Tone Arms & Bust',
        35,
        7,
        ['Chest', 'Arms'],
        '$_femaleGirlRoot/Tone arms & bust/Knee Pushups.png',
        '$_femaleVideoRoot/knee_pushups.mp4',
      ),
      _exercise(
        'Chair Dips',
        'Tone Arms & Bust',
        40,
        9,
        ['Triceps', 'Shoulders'],
        '$_femaleGirlRoot/Tone arms & bust/Chair Dips.png',
        '$_femaleVideoRoot/chair_dips.mp4',
      ),
      _exercise(
        'Arm Circles',
        'Tone Arms & Bust',
        45,
        6,
        ['Shoulders'],
        '$_femaleGirlRoot/Tone arms & bust/Arm Circle (2).png',
        '$_femaleVideoRoot/arm_circles.mp4',
      ),
      _exercise(
        'Cobra Stretch',
        'Tone Arms & Bust',
        30,
        3,
        ['Core', 'Back'],
        '$_femaleGirlRoot/Tone arms & bust/Cobra Switch.png',
        '$_femaleVideoRoot/cobra_stretch.mp4',
      ),
    ],
  ),
  WorkoutCategory(
    name: 'Full Body Fitness',
    subtitle: 'Efficient head-to-toe training',
    icon: Icons.bolt_rounded,
    color: const Color(0xFF93D500),
    exercises: [
      _exercise(
        'Burpees',
        'Full Body Fitness',
        35,
        15,
        ['Full body', 'Cardio'],
        '$_femaleGirlRoot/full body fitness/Burpees.png',
        '$_femaleVideoRoot/burpees.mp4',
      ),
      _exercise(
        'Mountain Climbers',
        'Full Body Fitness',
        40,
        14,
        ['Core', 'Cardio'],
        '$_femaleGirlRoot/full body fitness/Mountain Climber.png',
        '$_femaleVideoRoot/mountain_climbers.mp4',
      ),
      _exercise(
        'Standard Squats',
        'Full Body Fitness',
        45,
        12,
        ['Legs', 'Glutes'],
        '$_femaleGirlRoot/full body fitness/Stander Squatas.png',
        '$_femaleVideoRoot/full_body_standard_squats.mp4',
      ),
      _exercise(
        'Reverse Lunges',
        'Full Body Fitness',
        45,
        13,
        ['Legs', 'Balance'],
        '$_femaleGirlRoot/full body fitness/Reverse Lunges.png',
        '$_femaleVideoRoot/full_body_reverse_lunges.mp4',
      ),
      _exercise(
        'Classic Pushups',
        'Full Body Fitness',
        40,
        10,
        ['Chest', 'Arms'],
        '$_femaleGirlRoot/full body fitness/Classsic Pushups.png',
        '$_femaleVideoRoot/full_body_classic_pushups.mp4',
      ),
    ],
  ),
];

Exercise? findExerciseMediaSource(Exercise exercise) {
  final normalizedName = exercise.name.trim().toLowerCase();
  final normalizedCategory = exercise.category.trim().toLowerCase();
  final allExercises = workoutCategories.expand(
    (category) => category.exercises,
  );

  for (final candidate in allExercises) {
    if (candidate.name.trim().toLowerCase() == normalizedName &&
        candidate.category.trim().toLowerCase() == normalizedCategory) {
      return candidate;
    }
  }

  for (final candidate in allExercises) {
    if (candidate.name.trim().toLowerCase() == normalizedName) {
      return candidate;
    }
  }

  return null;
}

String? exerciseImageAssetFor(Exercise exercise) =>
    exercise.imageAsset ?? findExerciseMediaSource(exercise)?.imageAsset;

String? exerciseVideoAssetFor(Exercise exercise) =>
    exercise.videoAsset ?? findExerciseMediaSource(exercise)?.videoAsset;
