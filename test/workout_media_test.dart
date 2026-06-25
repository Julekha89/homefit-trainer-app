import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:homefit_trainer/data/workout_data.dart';
import 'package:homefit_trainer/models/workout.dart';

void main() {
  test('mapped male exercise media assets exist', () {
    final missing = <String>[];

    for (final category in workoutCategories) {
      for (final exercise in category.exercises) {
        final image = exerciseImageAssetFor(exercise, Gender.male);
        final video = exerciseVideoAssetFor(exercise, Gender.male);
        if (image != null && !File(image).existsSync()) missing.add(image);
        if (video != null && !File(video).existsSync()) missing.add(video);
      }
    }

    expect(missing, isEmpty);
  });

  test('male Plank uses the Boy exercise image and safe video asset', () {
    final plank = workoutCategories
        .expand((category) => category.exercises)
        .firstWhere((exercise) => exercise.name == 'Plank');

    expect(
      exerciseImageAssetFor(plank, Gender.male),
      'assets/exercises/male/Boy/Six-Pack ABS/Plank.png',
    );
    expect(
      exerciseVideoAssetFor(plank, Gender.male),
      'assets/exercises/male/videos/plank.mp4',
    );
  });
}
