import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../models/exercise_animation.dart';

class ExerciseAnimationLoader extends StatelessWidget {
  const ExerciseAnimationLoader({
    super.key,
    this.animation,
    required this.fallbackAsset,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  final ExerciseAnimation? animation;
  final String fallbackAsset;
  final BoxFit fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final value = animation;
    if (value == null || value.path.isEmpty) {
      return Image.asset(
        fallbackAsset,
        fit: fit,
        width: width,
        height: height,
        alignment: Alignment.topCenter,
      );
    }

    final lottie = value.source == AnimationSource.asset
        ? Lottie.asset(value.path, fit: fit, repeat: value.loop)
        : Lottie.network(value.path, fit: fit, repeat: value.loop);

    return lottie;
  }
}
