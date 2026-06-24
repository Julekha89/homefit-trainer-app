import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:homefit_trainer/data/workout_data.dart';

void main() {
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
