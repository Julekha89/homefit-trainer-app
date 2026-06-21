import 'package:flutter_test/flutter_test.dart';
import 'package:homefit_trainer/models/workout.dart';
import 'package:homefit_trainer/services/ai_trainer_service.dart';

void main() {
  const trainer = AiTrainerService();

  test('generates level-appropriate workout sizes', () {
    final beginner = trainer.generate(
      level: FitnessLevel.beginner,
      goal: FitnessGoal.stayFit,
    );
    final advanced = trainer.generate(
      level: FitnessLevel.advanced,
      goal: FitnessGoal.buildMuscle,
    );

    expect(beginner.exercises, hasLength(4));
    expect(beginner.rounds, 2);
    expect(advanced.exercises, hasLength(6));
    expect(advanced.rounds, 4);
  });
}
