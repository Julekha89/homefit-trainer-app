enum AnimationSource { asset, network }

class ExerciseAnimation {
  const ExerciseAnimation({
    required this.id,
    required this.exerciseName,
    required this.source,
    required this.path,
    this.loop = true,
  });

  final String id;
  final String exerciseName;
  final AnimationSource source;
  final String path;
  final bool loop;
}
