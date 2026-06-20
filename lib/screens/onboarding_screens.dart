import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/app_theme.dart';
import '../models/health_models.dart';
import '../models/workout.dart';
import '../services/firebase_service.dart';
import '../services/firestore_service.dart';
import '../widgets/common_widgets.dart';
import 'main_shell.dart';

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({super.key});

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  Gender _gender = Gender.female;

  @override
  Widget build(BuildContext context) {
    return _OnboardingLayout(
      step: '1 of 3',
      title: 'Choose your guide',
      subtitle:
          'We will use the matching exercise guide as a placeholder for your workouts.',
      body: Row(
        children: Gender.values.map((gender) {
          final selected = gender == _gender;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: gender == Gender.female ? 8 : 0,
                left: gender == Gender.male ? 8 : 0,
              ),
              child: GestureDetector(
                onTap: () => setState(() => _gender = gender),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 360,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: selected ? gender.color : const Color(0xFFE2E8EF),
                      width: selected ? 3 : 1,
                    ),
                    color: Colors.white,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(gender.asset, fit: BoxFit.cover),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              gender.color.withValues(alpha: 0.90),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                selected
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                gender.label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
      onContinue: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => GoalSelectionScreen(gender: _gender),
        ),
      ),
    );
  }
}

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key, required this.gender});

  final Gender gender;

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  FitnessGoal _goal = FitnessGoal.stayFit;

  @override
  Widget build(BuildContext context) {
    return _OnboardingLayout(
      step: '2 of 3',
      title: 'What is your goal?',
      subtitle: 'Your plan will highlight workouts that support your target.',
      body: Column(
        children: FitnessGoal.values
            .map(
              (goal) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: SelectionCard(
                  title: goal.label,
                  subtitle: goal.description,
                  icon: goal.icon,
                  selected: goal == _goal,
                  onTap: () => setState(() => _goal = goal),
                ),
              ),
            )
            .toList(),
      ),
      onContinue: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              LevelSelectionScreen(gender: widget.gender, goal: _goal),
        ),
      ),
    );
  }
}

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({
    super.key,
    required this.gender,
    required this.goal,
  });

  final Gender gender;
  final FitnessGoal goal;

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  FitnessLevel _level = FitnessLevel.beginner;

  @override
  Widget build(BuildContext context) {
    return _OnboardingLayout(
      step: '3 of 3',
      title: 'Choose your level',
      subtitle: 'Start where you feel comfortable. You can change this later.',
      body: Column(
        children: FitnessLevel.values
            .map(
              (level) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: SelectionCard(
                  title: level.label,
                  subtitle: level.description,
                  icon: switch (level) {
                    FitnessLevel.beginner => Icons.eco_rounded,
                    FitnessLevel.intermediate => Icons.trending_up_rounded,
                    FitnessLevel.advanced => Icons.bolt_rounded,
                  },
                  selected: level == _level,
                  color: AppColors.lime,
                  onTap: () => setState(() => _level = level),
                ),
              ),
            )
            .toList(),
      ),
      continueLabel: 'Build my plan',
      onContinue: () async {
        final user = FirebaseService.instance.isConfigured
            ? FirebaseAuth.instance.currentUser
            : null;
        await FirestoreService.instance.saveProfile(
          UserProfile(
            id: user?.uid ?? 'demo-user',
            email: user?.email ?? 'athlete@homefit.app',
            displayName: user?.displayName ?? 'HomeFit Athlete',
            gender: widget.gender,
            goal: widget.goal,
            level: _level,
          ),
        );
        if (!context.mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(
            builder: (_) => MainShell(
              gender: widget.gender,
              goal: widget.goal,
              level: _level,
            ),
          ),
          (route) => false,
        );
      },
    );
  }
}

class _OnboardingLayout extends StatelessWidget {
  const _OnboardingLayout({
    required this.step,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.onContinue,
    this.continueLabel = 'Continue',
  });

  final String step;
  final String title;
  final String subtitle;
  final Widget body;
  final VoidCallback onContinue;
  final String continueLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SETUP  $step',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScreenTitle(title: title, subtitle: subtitle),
                      const SizedBox(height: 28),
                      body,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              FilledButton(onPressed: onContinue, child: Text(continueLabel)),
            ],
          ),
        ),
      ),
    );
  }
}
