import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/workout.dart';
import '../services/ai_trainer_service.dart';
import 'exercise_detail_screen.dart';

class AiTrainerScreen extends StatefulWidget {
  const AiTrainerScreen({
    super.key,
    required this.gender,
    required this.initialGoal,
    required this.initialLevel,
  });

  final Gender gender;
  final FitnessGoal initialGoal;
  final FitnessLevel initialLevel;

  @override
  State<AiTrainerScreen> createState() => _AiTrainerScreenState();
}

class _AiTrainerScreenState extends State<AiTrainerScreen> {
  final _trainer = const AiTrainerService();
  late FitnessGoal _goal;
  late FitnessLevel _level;
  int _seed = 0;

  @override
  void initState() {
    super.initState();
    _goal = widget.initialGoal;
    _level = widget.initialLevel;
  }

  @override
  Widget build(BuildContext context) {
    final workout = _trainer.generate(level: _level, goal: _goal, seed: _seed);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI Trainer',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            tooltip: 'Generate a new workout',
            onPressed: () => setState(() => _seed++),
            icon: const Icon(Icons.auto_awesome_rounded),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7137FF), Color(0xFF00B8D9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 34,
                ),
                const SizedBox(height: 22),
                Text(
                  workout.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${workout.durationMinutes} min • ${workout.rounds} rounds\n${workout.summary}',
                  style: const TextStyle(color: Colors.white, height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<FitnessLevel>(
                  initialValue: _level,
                  decoration: const InputDecoration(labelText: 'Level'),
                  items: FitnessLevel.values
                      .map(
                        (level) => DropdownMenuItem(
                          value: level,
                          child: Text(level.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _level = value);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<FitnessGoal>(
                  initialValue: _goal,
                  decoration: const InputDecoration(labelText: 'Goal'),
                  items: FitnessGoal.values
                      .map(
                        (goal) => DropdownMenuItem(
                          value: goal,
                          child: Text(goal.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _goal = value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your generated circuit',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              TextButton.icon(
                onPressed: () => setState(() => _seed++),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Regenerate'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...workout.exercises.indexed.map(
            (entry) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(14),
                leading: CircleAvatar(
                  backgroundColor: AppColors.cyan.withValues(alpha: 0.14),
                  child: Text(
                    '${entry.$1 + 1}',
                    style: const TextStyle(
                      color: AppColors.cyan,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                title: Text(
                  entry.$2.name,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                subtitle: Text(
                  '${entry.$2.durationSeconds}s • ${entry.$2.category}',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ExerciseDetailScreen(
                      exercise: entry.$2,
                      gender: widget.gender,
                      level: _level,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
