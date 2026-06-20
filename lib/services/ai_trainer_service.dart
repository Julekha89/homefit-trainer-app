import '../data/workout_data.dart';
import '../models/workout.dart';

class GeneratedWorkout {
  const GeneratedWorkout({
    required this.title,
    required this.summary,
    required this.level,
    required this.rounds,
    required this.exercises,
  });

  final String title;
  final String summary;
  final FitnessLevel level;
  final int rounds;
  final List<Exercise> exercises;

  int get durationMinutes {
    final seconds = exercises.fold<int>(
      0,
      (total, exercise) => total + exercise.durationSeconds + 20,
    );
    return ((seconds * rounds) / 60).ceil();
  }
}

class AiTrainerService {
  const AiTrainerService();

  GeneratedWorkout generate({
    required FitnessLevel level,
    required FitnessGoal goal,
    int seed = 0,
  }) {
    final pool = workoutCategories.expand((category) => category.exercises);
    final unique = <String, Exercise>{};
    for (final exercise in pool) {
      unique.putIfAbsent(exercise.name, () => exercise);
    }

    final ranked = unique.values.toList()
      ..sort((a, b) {
        final aScore = _score(a, goal, seed);
        final bScore = _score(b, goal, seed);
        return bScore.compareTo(aScore);
      });

    final count = switch (level) {
      FitnessLevel.beginner => 4,
      FitnessLevel.intermediate => 5,
      FitnessLevel.advanced => 6,
    };
    final selected = ranked.take(count).toList();

    return GeneratedWorkout(
      title: '${level.label} ${goal.label} session',
      summary:
          '${level.rounds} rounds combining ${selected.map((e) => e.category).toSet().length} training styles.',
      level: level,
      rounds: level.rounds,
      exercises: selected,
    );
  }

  int _score(Exercise exercise, FitnessGoal goal, int seed) {
    final text = '${exercise.name} ${exercise.category}'.toLowerCase();
    final goalScore = switch (goal) {
      FitnessGoal.loseWeight =>
        text.contains('full') ||
                text.contains('climber') ||
                text.contains('burpee')
            ? 30
            : exercise.calories,
      FitnessGoal.buildMuscle =>
        text.contains('upper') ||
                text.contains('lower') ||
                text.contains('squat') ||
                text.contains('push')
            ? 30
            : 5,
      FitnessGoal.stayFit => 15,
    };
    return goalScore + exercise.name.codeUnits.fold(seed, (a, b) => a + b) % 17;
  }
}
