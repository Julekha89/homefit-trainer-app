class FitnessCalculatorService {
  const FitnessCalculatorService();

  double bmi({required double weightKg, required double heightCm}) {
    final meters = heightCm / 100;
    if (meters <= 0) return 0;
    return weightKg / (meters * meters);
  }

  String bmiCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Healthy range';
    if (bmi < 30) return 'Overweight';
    return 'Obesity range';
  }

  double caloriesBurned({
    required double met,
    required double weightKg,
    required int minutes,
  }) {
    return met * 3.5 * weightKg / 200 * minutes;
  }
}
