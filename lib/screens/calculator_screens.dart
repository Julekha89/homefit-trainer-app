import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../services/fitness_calculator_service.dart';

class BmiCalculatorScreen extends StatefulWidget {
  const BmiCalculatorScreen({super.key});

  @override
  State<BmiCalculatorScreen> createState() => _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends State<BmiCalculatorScreen> {
  final _service = const FitnessCalculatorService();
  double _height = 170;
  double _weight = 70;

  @override
  Widget build(BuildContext context) {
    final bmi = _service.bmi(weightKg: _weight, heightCm: _height);
    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _ResultHero(
            label: 'YOUR BMI',
            value: bmi.toStringAsFixed(1),
            subtitle: _service.bmiCategory(bmi),
            color: AppColors.cyan,
          ),
          const SizedBox(height: 20),
          _MetricSlider(
            title: 'Height',
            value: _height,
            min: 120,
            max: 220,
            unit: 'cm',
            onChanged: (value) => setState(() => _height = value),
          ),
          const SizedBox(height: 14),
          _MetricSlider(
            title: 'Weight',
            value: _weight,
            min: 35,
            max: 180,
            unit: 'kg',
            onChanged: (value) => setState(() => _weight = value),
          ),
          const SizedBox(height: 18),
          const Text(
            'BMI is a general screening measure and does not replace professional medical advice.',
            style: TextStyle(color: AppColors.muted, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class CaloriesCalculatorScreen extends StatefulWidget {
  const CaloriesCalculatorScreen({super.key});

  @override
  State<CaloriesCalculatorScreen> createState() =>
      _CaloriesCalculatorScreenState();
}

class _CaloriesCalculatorScreenState extends State<CaloriesCalculatorScreen> {
  final _service = const FitnessCalculatorService();
  double _weight = 70;
  double _met = 6;
  double _minutes = 30;

  @override
  Widget build(BuildContext context) {
    final calories = _service.caloriesBurned(
      met: _met,
      weightKg: _weight,
      minutes: _minutes.round(),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Calories Burned')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _ResultHero(
            label: 'ESTIMATED BURN',
            value: calories.round().toString(),
            subtitle: 'kilocalories',
            color: const Color(0xFFFF7043),
          ),
          const SizedBox(height: 20),
          _MetricSlider(
            title: 'Weight',
            value: _weight,
            min: 35,
            max: 180,
            unit: 'kg',
            onChanged: (value) => setState(() => _weight = value),
          ),
          const SizedBox(height: 14),
          _MetricSlider(
            title: 'Duration',
            value: _minutes,
            min: 5,
            max: 120,
            unit: 'min',
            onChanged: (value) => setState(() => _minutes = value),
          ),
          const SizedBox(height: 14),
          _MetricSlider(
            title: 'Intensity',
            value: _met,
            min: 2,
            max: 12,
            unit: 'MET',
            onChanged: (value) => setState(() => _met = value),
          ),
        ],
      ),
    );
  }
}

class _ResultHero extends StatelessWidget {
  const _ResultHero({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  final String label;
  final String value;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.65)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 64,
              height: 1,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class _MetricSlider extends StatelessWidget {
  const _MetricSlider({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.onChanged,
  });

  final String title;
  final double value;
  final double min;
  final double max;
  final String unit;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  '${value.round()} $unit',
                  style: const TextStyle(
                    color: AppColors.cyan,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            Slider(value: value, min: min, max: max, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
