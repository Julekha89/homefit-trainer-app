import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../core/app_theme.dart';
import '../data/workout_data.dart';
import '../models/workout.dart';
import '../services/auth_service.dart';
import '../widgets/common_widgets.dart';
import 'ai_trainer_screen.dart';
import 'calculator_screens.dart';
import 'exercise_detail_screen.dart';
import 'weight_tracking_screen.dart';
import 'workout_history_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.gender,
    required this.goal,
    required this.level,
  });

  final Gender gender;
  final FitnessGoal goal;
  final FitnessLevel level;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeDashboard(
        gender: widget.gender,
        goal: widget.goal,
        level: widget.level,
        onBrowse: () => setState(() => _index = 1),
      ),
      WorkoutCategoriesPage(gender: widget.gender, level: widget.level),
      AiTrainerScreen(
        gender: widget.gender,
        initialGoal: widget.goal,
        initialLevel: widget.level,
      ),
      const ProgressPage(),
      ProfilePage(
        gender: widget.gender,
        goal: widget.goal,
        level: widget.level,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center_rounded),
            label: 'Workouts',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome_rounded),
            label: 'Trainer',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights_rounded),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({
    super.key,
    required this.gender,
    required this.goal,
    required this.level,
    required this.onBrowse,
  });

  final Gender gender;
  final FitnessGoal goal;
  final FitnessLevel level;
  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    final featured = workoutCategories.first.exercises.first;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              sliver: SliverList.list(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: gender.color.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          gender == Gender.female
                              ? Icons.female_rounded
                              : Icons.male_rounded,
                          color: gender.color,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good morning,',
                              style: TextStyle(color: AppColors.muted),
                            ),
                            Text(
                              'HomeFit Athlete',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_none_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.navy, Color(0xFF12324C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TODAY\'S PLAN',
                          style: TextStyle(
                            color: AppColors.lime,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.6,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${level.label} ${goal.label}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${level.rounds} rounds • 18 min • Full body',
                          style: const TextStyle(color: Color(0xFFB9C8D5)),
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.lime,
                            foregroundColor: AppColors.navy,
                            minimumSize: const Size.fromHeight(50),
                          ),
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => ExerciseDetailScreen(
                                exercise: featured,
                                gender: gender,
                                level: level,
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('Start today\'s workout'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Row(
                    children: [
                      StatTile(
                        icon: Icons.local_fire_department_rounded,
                        value: '1,240',
                        label: 'Calories',
                        color: Color(0xFFFF7043),
                      ),
                      SizedBox(width: 10),
                      StatTile(
                        icon: Icons.timer_outlined,
                        value: '184 min',
                        label: 'Active time',
                        color: AppColors.cyan,
                      ),
                      SizedBox(width: 10),
                      StatTile(
                        icon: Icons.bolt_rounded,
                        value: '6 days',
                        label: 'Current streak',
                        color: AppColors.lime,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Workout categories',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TextButton(
                        onPressed: onBrowse,
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 154,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: workoutCategories.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final category = workoutCategories[index];
                        return _CategoryMiniCard(
                          category: category,
                          onTap: () => onBrowse(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Exercise guide preview',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      gender.asset,
                      height: 310,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryMiniCard extends StatelessWidget {
  const _CategoryMiniCard({required this.category, required this.onTap});

  final WorkoutCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Material(
        color: category.color,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(category.icon, color: Colors.white, size: 30),
                const Spacer(),
                Text(
                  category.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${category.exercises.length} exercises',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WorkoutCategoriesPage extends StatelessWidget {
  const WorkoutCategoriesPage({
    super.key,
    required this.gender,
    required this.level,
  });

  final Gender gender;
  final FitnessLevel level;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Workouts',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        itemCount: workoutCategories.length,
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final category = workoutCategories[index];
          return Card(
            child: ExpansionTile(
              tilePadding: const EdgeInsets.all(18),
              childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(category.icon, color: category.color),
              ),
              title: Text(
                category.name,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              subtitle: Text(category.subtitle),
              children: category.exercises
                  .map(
                    (exercise) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: _ExerciseCardImage(
                        exercise: exercise,
                        gender: gender,
                        color: category.color,
                      ),
                      title: Text(
                        exercise.name,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        '${exercise.durationSeconds}s • ${exercise.calories} kcal',
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ExerciseDetailScreen(
                            exercise: exercise,
                            gender: gender,
                            level: level,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}

class _ExerciseCardImage extends StatelessWidget {
  const _ExerciseCardImage({
    required this.exercise,
    required this.gender,
    required this.color,
  });

  final Exercise exercise;
  final Gender gender;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final imageAsset = exerciseImageAssetFor(exercise, gender);
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 56,
        height: 56,
        color: color.withValues(alpha: 0.14),
        child: imageAsset == null
            ? Icon(Icons.play_arrow_rounded, color: color)
            : Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Icon(Icons.play_arrow_rounded, color: color),
              ),
      ),
    );
  }
}

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    const activity = [0.35, 0.65, 0.45, 0.90, 0.55, 0.78, 0.30];
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your progress',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.cyan, Color(0xFF0688D7)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Row(
              children: [
                Icon(Icons.emoji_events_rounded, color: Colors.white, size: 42),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '6 day streak!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'One more workout beats your personal best.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Weekly activity',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 180,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(activity.length, (index) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: FractionallySizedBox(
                                      heightFactor: activity[index],
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: index == 3
                                              ? AppColors.lime
                                              : AppColors.cyan,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  days[index],
                                  style: const TextStyle(
                                    color: AppColors.muted,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              StatTile(
                icon: Icons.check_circle_rounded,
                value: '18',
                label: 'Workouts',
                color: AppColors.lime,
              ),
              SizedBox(width: 12),
              StatTile(
                icon: Icons.local_fire_department_rounded,
                value: '1,240',
                label: 'Calories',
                color: Color(0xFFFF7043),
              ),
              SizedBox(width: 12),
              StatTile(
                icon: Icons.timer_rounded,
                value: '184m',
                label: 'Duration',
                color: AppColors.cyan,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Monthly goal',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '18 of 24 workouts completed',
                    style: TextStyle(color: AppColors.muted),
                  ),
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const LinearProgressIndicator(
                      value: 0.75,
                      minHeight: 14,
                      backgroundColor: Color(0xFFE7EDF2),
                      color: AppColors.lime,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const WorkoutHistoryScreen(),
              ),
            ),
            icon: const Icon(Icons.history_rounded),
            label: const Text('View workout history'),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.gender,
    required this.goal,
    required this.level,
  });

  final Gender gender;
  final FitnessGoal goal;
  final FitnessLevel level;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_rounded),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: gender.color.withValues(alpha: 0.14),
                    child: Icon(
                      gender == Gender.female
                          ? Icons.female_rounded
                          : Icons.male_rounded,
                      color: gender.color,
                      size: 34,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HomeFit Athlete',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'athlete@homefit.app',
                          style: TextStyle(color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Training preferences',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                _ProfileTile(
                  icon: gender == Gender.female
                      ? Icons.female_rounded
                      : Icons.male_rounded,
                  title: 'Exercise guide',
                  value: gender.label,
                  color: gender.color,
                ),
                const Divider(height: 1),
                _ProfileTile(
                  icon: goal.icon,
                  title: 'Primary goal',
                  value: goal.label,
                  color: AppColors.cyan,
                ),
                const Divider(height: 1),
                _ProfileTile(
                  icon: Icons.trending_up_rounded,
                  title: 'Fitness level',
                  value: level.label,
                  color: AppColors.lime,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Health tools',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                _ActionTile(
                  icon: Icons.monitor_weight_outlined,
                  title: 'Weight tracking',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const WeightTrackingScreen(),
                    ),
                  ),
                ),
                const Divider(height: 1),
                _ActionTile(
                  icon: Icons.calculate_outlined,
                  title: 'BMI calculator',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const BmiCalculatorScreen(),
                    ),
                  ),
                ),
                const Divider(height: 1),
                _ActionTile(
                  icon: Icons.local_fire_department_outlined,
                  title: 'Calories burned calculator',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const CaloriesCalculatorScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Account',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: const Text('Dark mode'),
                  value: AppControllerScope.of(context).isDarkMode,
                  onChanged: AppControllerScope.of(context).setDarkMode,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 3,
                  ),
                ),
                const Divider(height: 1),
                _ActionTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _ActionTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & support',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _ActionTile(
                  icon: Icons.logout_rounded,
                  title: 'Log out',
                  onTap: () async {
                    await AuthService.instance.signOut();
                    if (!context.mounted) return;
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/', (route) => false);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      leading: Icon(icon, color: color),
      title: Text(title),
      trailing: Text(
        value,
        style: const TextStyle(
          color: AppColors.muted,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
