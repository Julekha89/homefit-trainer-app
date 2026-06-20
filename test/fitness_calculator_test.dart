import 'package:flutter_test/flutter_test.dart';
import 'package:homefit_trainer/services/fitness_calculator_service.dart';

void main() {
  const calculator = FitnessCalculatorService();

  test('calculates BMI and category', () {
    final bmi = calculator.bmi(weightKg: 70, heightCm: 175);

    expect(bmi, closeTo(22.86, 0.01));
    expect(calculator.bmiCategory(bmi), 'Healthy range');
  });

  test('calculates calories using MET formula', () {
    final calories = calculator.caloriesBurned(
      met: 6,
      weightKg: 70,
      minutes: 30,
    );

    expect(calories, closeTo(220.5, 0.01));
  });
}
