import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homefit_trainer/data/workout_data.dart';
import 'package:homefit_trainer/models/workout.dart';
import 'package:homefit_trainer/screens/exercise_detail_screen.dart';
import 'package:homefit_trainer/screens/workout_timer_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('plank uses dedicated female exercise media', () {
    final plank = workoutCategories
        .expand((category) => category.exercises)
        .singleWhere(
          (exercise) =>
              exercise.name == 'Plank' && exercise.category == 'Belly Slimming',
        );

    expect(
      plank.imageAsset,
      'assets/exercises/female/Girl/Belly slimming/Plank.png',
    );
    expect(
      plank.videoAsset,
      'assets/exercises/female/Girl/Belly slimming/plank.mp4',
    );
    expect(
      plank.imageAsset,
      isNot('assets/exercises/female/female.png'),
      reason: 'Plank detail must not use the full female infographic poster.',
    );
  });

  testWidgets('plank Android detail fallback uses Plank image, not poster', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final plank = workoutCategories
        .expand((category) => category.exercises)
        .singleWhere(
          (exercise) =>
              exercise.name == 'Plank' && exercise.category == 'Belly Slimming',
        );
    final plankWithoutVideo = Exercise(
      name: plank.name,
      category: plank.category,
      durationSeconds: plank.durationSeconds,
      calories: plank.calories,
      instructions: plank.instructions,
      muscles: plank.muscles,
      imageAsset: plank.imageAsset,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.android),
        home: ExerciseDetailScreen(
          exercise: plankWithoutVideo,
          gender: Gender.female,
          level: FitnessLevel.beginner,
        ),
      ),
    );

    final plankImage = find.byWidgetPredicate((widget) {
      return widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/exercises/female/Girl/Belly slimming/Plank.png';
    });
    final posterImage = find.byWidgetPredicate((widget) {
      return widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/exercises/female/female.png';
    });

    expect(plankImage, findsOneWidget);
    expect(posterImage, findsNothing);
  });

  testWidgets('plank Android timer fallback uses Plank image, not poster', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final plank = workoutCategories
        .expand((category) => category.exercises)
        .singleWhere(
          (exercise) =>
              exercise.name == 'Plank' && exercise.category == 'Belly Slimming',
        );
    final plankWithoutVideo = Exercise(
      name: plank.name,
      category: plank.category,
      durationSeconds: plank.durationSeconds,
      calories: plank.calories,
      instructions: plank.instructions,
      muscles: plank.muscles,
      imageAsset: plank.imageAsset,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.android),
        home: WorkoutTimerScreen(
          exercise: plankWithoutVideo,
          gender: Gender.female,
        ),
      ),
    );

    final plankImage = find.byWidgetPredicate((widget) {
      return widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/exercises/female/Girl/Belly slimming/Plank.png';
    });
    final posterImage = find.byWidgetPredicate((widget) {
      return widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/exercises/female/female.png';
    });

    expect(plankImage, findsOneWidget);
    expect(posterImage, findsNothing);
  });

  testWidgets('plank Android timer opens with image before start', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final plank = workoutCategories
        .expand((category) => category.exercises)
        .singleWhere(
          (exercise) =>
              exercise.name == 'Plank' && exercise.category == 'Belly Slimming',
        );

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.android),
        home: WorkoutTimerScreen(exercise: plank, gender: Gender.female),
      ),
    );

    final plankImage = find.byWidgetPredicate((widget) {
      return widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/exercises/female/Girl/Belly slimming/Plank.png';
    });
    final posterImage = find.byWidgetPredicate((widget) {
      return widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/exercises/female/female.png';
    });

    expect(plankImage, findsOneWidget);
    expect(posterImage, findsNothing);
  });

  testWidgets(
    'plank timer resolves media even when exercise has no asset paths',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const partialPlank = Exercise(
        name: 'Plank',
        category: 'Belly Slimming',
        durationSeconds: 30,
        calories: 6,
        instructions: ['Hold a strong plank position.'],
        muscles: ['Core', 'Shoulders'],
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.android),
          home: const WorkoutTimerScreen(
            exercise: partialPlank,
            gender: Gender.female,
          ),
        ),
      );

      final plankImage = find.byWidgetPredicate((widget) {
        return widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/exercises/female/Girl/Belly slimming/Plank.png';
      });
      final posterImage = find.byWidgetPredicate((widget) {
        return widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/exercises/female/female.png';
      });

      expect(plankImage, findsOneWidget);
      expect(posterImage, findsNothing);
    },
  );

  test('female exercise media assets exist', () {
    final exercises = workoutCategories.expand(
      (category) => category.exercises,
    );

    for (final exercise in exercises) {
      final imageAsset = exercise.imageAsset;
      final videoAsset = exercise.videoAsset;

      expect(imageAsset, isNotNull, reason: '${exercise.name} needs an image');
      expect(videoAsset, isNotNull, reason: '${exercise.name} needs a video');
      expect(
        File(imageAsset!).existsSync(),
        isTrue,
        reason: '${exercise.name} image does not exist: $imageAsset',
      );
      expect(
        File(videoAsset!).existsSync(),
        isTrue,
        reason: '${exercise.name} video does not exist: $videoAsset',
      );
    }
  });
}
