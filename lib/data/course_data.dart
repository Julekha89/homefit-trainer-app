import '../models/workout.dart';

List<CoursePlan> recommendedCoursePlans({
  required Gender gender,
  required FitnessGoal goal,
  required FitnessLevel level,
}) {
  return CourseLength.values
      .map(
        (length) => _buildCoursePlan(
          gender: gender,
          goal: goal,
          level: level,
          length: length,
        ),
      )
      .toList(growable: false);
}

CoursePlan _buildCoursePlan({
  required Gender gender,
  required FitnessGoal goal,
  required FitnessLevel level,
  required CourseLength length,
}) {
  final genderLabel = gender.label;
  final goalLabel = goal.label;
  final levelLabel = level.label;
  final workoutDays = _workoutDaysPerWeek(level, length);
  final minutes = _minutesPerDay(level, length);

  return CoursePlan(
    id: '${gender.name}-${goal.name}-${level.name}-${length.name}',
    gender: gender,
    goal: goal,
    level: level,
    length: length,
    title: '${length.label} $goalLabel $levelLabel',
    subtitle: '$genderLabel ${length.productName}',
    description: _description(goal, level, length),
    workoutDaysPerWeek: workoutDays,
    minutesPerDay: minutes,
    phases: _phases(length),
    weeklySchedule: _weeklySchedule(gender, goal, level, length),
  );
}

int _workoutDaysPerWeek(FitnessLevel level, CourseLength length) {
  return switch ((level, length)) {
    (FitnessLevel.beginner, CourseLength.thirtyDays) => 4,
    (FitnessLevel.beginner, CourseLength.ninetyDays) => 5,
    (FitnessLevel.intermediate, _) => 5,
    (FitnessLevel.advanced, CourseLength.thirtyDays) => 5,
    (FitnessLevel.advanced, CourseLength.ninetyDays) => 6,
  };
}

String _minutesPerDay(FitnessLevel level, CourseLength length) {
  return switch ((level, length)) {
    (FitnessLevel.beginner, CourseLength.thirtyDays) => '15-25 min',
    (FitnessLevel.beginner, CourseLength.ninetyDays) => '20-30 min',
    (FitnessLevel.intermediate, CourseLength.thirtyDays) => '25-35 min',
    (FitnessLevel.intermediate, CourseLength.ninetyDays) => '30-40 min',
    (FitnessLevel.advanced, CourseLength.thirtyDays) => '30-45 min',
    (FitnessLevel.advanced, CourseLength.ninetyDays) => '35-50 min',
  };
}

String _description(FitnessGoal goal, FitnessLevel level, CourseLength length) {
  final outcome = switch (goal) {
    FitnessGoal.loseWeight => 'burn fat, improve stamina, and stay consistent',
    FitnessGoal.buildMuscle => 'build strength, tone muscle, and improve power',
    FitnessGoal.stayFit => 'maintain energy, mobility, and full-body fitness',
  };
  final intensity = switch (level) {
    FitnessLevel.beginner => 'gentle progression and clear form practice',
    FitnessLevel.intermediate => 'steady progression and balanced intensity',
    FitnessLevel.advanced =>
      'higher intensity challenges and stronger finishers',
  };
  final duration = switch (length) {
    CourseLength.thirtyDays => 'a focused starter transformation',
    CourseLength.ninetyDays => 'a complete transformation journey',
  };

  return 'A $duration designed to $outcome with $intensity.';
}

List<CoursePhase> _phases(CourseLength length) {
  return switch (length) {
    CourseLength.thirtyDays => const [
      CoursePhase(
        title: 'Week 1: Foundation',
        description: 'Learn form, start easy, and build workout confidence.',
      ),
      CoursePhase(
        title: 'Week 2: Build Stamina',
        description:
            'Add more time under tension and improve breathing rhythm.',
      ),
      CoursePhase(
        title: 'Week 3: Increase Intensity',
        description: 'Push harder with stronger circuits and shorter rests.',
      ),
      CoursePhase(
        title: 'Week 4: Challenge Week',
        description: 'Finish with full-body challenges and progress tracking.',
      ),
    ],
    CourseLength.ninetyDays => const [
      CoursePhase(
        title: 'Month 1: Foundation',
        description: 'Create the habit, learn form, and build base endurance.',
      ),
      CoursePhase(
        title: 'Month 2: Progression',
        description: 'Increase rounds, intensity, and workout consistency.',
      ),
      CoursePhase(
        title: 'Month 3: Transformation',
        description: 'Complete tougher challenges and track visible progress.',
      ),
    ],
  };
}

List<CourseWeek> _weeklySchedule(
  Gender gender,
  FitnessGoal goal,
  FitnessLevel level,
  CourseLength length,
) {
  final days = switch ((gender, goal, level)) {
    (Gender.female, FitnessGoal.loseWeight, FitnessLevel.beginner) => const [
      'Belly Slimming',
      'Full Body Fitness',
      'Rest / Stretch',
      'Slender Legs & Thighs',
      'Tone Arms & Bust',
      'Light Cardio / Walk',
      'Rest',
    ],
    (Gender.female, FitnessGoal.loseWeight, FitnessLevel.intermediate) =>
      const [
        'Belly Slimming + Cardio',
        'Glutes & Butt Sculpt',
        'Full Body Fitness',
        'Rest / Mobility',
        'Slender Legs & Thighs',
        'Full Body Fitness Challenge',
        'Rest',
      ],
    (Gender.female, FitnessGoal.loseWeight, FitnessLevel.advanced) => const [
      'HIIT Belly Slimming',
      'Legs & Thighs Burn',
      'Full Body Fitness',
      'Glutes & Core',
      'Tone Arms + Cardio',
      'Full Body Challenge',
      'Rest',
    ],
    (Gender.female, FitnessGoal.buildMuscle, FitnessLevel.beginner) => const [
      'Glutes & Butt Sculpt',
      'Tone Arms & Bust',
      'Rest',
      'Slender Legs & Thighs',
      'Core Strength',
      'Mobility',
      'Rest',
    ],
    (Gender.female, FitnessGoal.buildMuscle, FitnessLevel.intermediate) =>
      const [
        'Glutes & Butt Sculpt',
        'Tone Arms & Bust',
        'Legs & Thighs',
        'Rest',
        'Core + Full Body',
        'Glutes + Lower Body',
        'Rest',
      ],
    (Gender.female, FitnessGoal.buildMuscle, FitnessLevel.advanced) => const [
      'Lower Body Strength',
      'Upper Body Tone',
      'Glutes Power',
      'Core Strength',
      'Full Body Strength',
      'Legs + Glutes Challenge',
      'Rest',
    ],
    (Gender.female, FitnessGoal.stayFit, FitnessLevel.beginner) => const [
      'Full Body Easy',
      'Belly Slimming',
      'Rest',
      'Legs & Thighs',
      'Stretch / Mobility',
      'Light Full Body',
      'Rest',
    ],
    (Gender.female, FitnessGoal.stayFit, FitnessLevel.intermediate) => const [
      'Full Body Fitness',
      'Core + Belly',
      'Glutes & Legs',
      'Mobility',
      'Arms + Bust',
      'Full Body Flow',
      'Rest',
    ],
    (Gender.female, FitnessGoal.stayFit, FitnessLevel.advanced) => const [
      'Full Body Challenge',
      'Core Power',
      'Legs + Glutes',
      'Mobility',
      'Upper Body Tone',
      'Athletic Full Body',
      'Rest',
    ],
    (Gender.male, FitnessGoal.loseWeight, FitnessLevel.beginner) => const [
      'Six-Pack ABS',
      'Full Body Fitness',
      'Rest / Stretch',
      'Legs & Thighs',
      'Chest & Arms Build',
      'Light Cardio / Walk',
      'Rest',
    ],
    (Gender.male, FitnessGoal.loseWeight, FitnessLevel.intermediate) => const [
      'Six-Pack ABS + Cardio',
      'Full Body Fitness',
      'Legs & Thighs',
      'Rest / Mobility',
      'Chest & Arms Build',
      'Full Body Challenge',
      'Rest',
    ],
    (Gender.male, FitnessGoal.loseWeight, FitnessLevel.advanced) => const [
      'HIIT ABS',
      'Legs Burn',
      'Full Body Fitness',
      'Chest & Arms Cardio',
      'Shoulder & Back Power',
      'Full Body Challenge',
      'Rest',
    ],
    (Gender.male, FitnessGoal.buildMuscle, FitnessLevel.beginner) => const [
      'Chest & Arms Build',
      'Legs & Thighs',
      'Rest',
      'Six-Pack ABS',
      'Shoulder & Back Power',
      'Mobility',
      'Rest',
    ],
    (Gender.male, FitnessGoal.buildMuscle, FitnessLevel.intermediate) => const [
      'Chest & Arms Build',
      'Legs & Thighs',
      'Six-Pack ABS',
      'Rest',
      'Shoulder & Back Power',
      'Full Body Strength',
      'Rest',
    ],
    (Gender.male, FitnessGoal.buildMuscle, FitnessLevel.advanced) => const [
      'Chest & Arms Strength',
      'Legs Strength',
      'Shoulder & Back Power',
      'Six-Pack ABS',
      'Full Body Power',
      'Upper Body Challenge',
      'Rest',
    ],
    (Gender.male, FitnessGoal.stayFit, FitnessLevel.beginner) => const [
      'Full Body Easy',
      'Six-Pack ABS',
      'Rest',
      'Legs & Thighs',
      'Shoulder & Back Mobility',
      'Light Full Body',
      'Rest',
    ],
    (Gender.male, FitnessGoal.stayFit, FitnessLevel.intermediate) => const [
      'Full Body Fitness',
      'Six-Pack ABS',
      'Chest & Arms',
      'Mobility',
      'Legs & Thighs',
      'Full Body Flow',
      'Rest',
    ],
    (Gender.male, FitnessGoal.stayFit, FitnessLevel.advanced) => const [
      'Athletic Full Body',
      'ABS Power',
      'Chest & Arms',
      'Shoulder & Back Power',
      'Legs Conditioning',
      'Full Body Challenge',
      'Rest',
    ],
  };

  return _buildWeeklyCourseSchedule(days, length);
}

List<CourseWeek> _buildWeeklyCourseSchedule(
  List<String> baseDays,
  CourseLength length,
) {
  final weekCount = switch (length) {
    CourseLength.thirtyDays => 4,
    CourseLength.ninetyDays => 13,
  };

  return List.generate(weekCount, (index) {
    final weekNumber = index + 1;
    final isFinalShortWeek =
        length == CourseLength.ninetyDays && weekNumber == 13;
    final sourceDays = isFinalShortWeek ? baseDays.take(6) : baseDays;

    return CourseWeek(
      title: _weekTitle(weekNumber, length),
      days: sourceDays
          .map((day) => _progressedExerciseName(day, weekNumber, length))
          .toList(growable: false),
    );
  });
}

String _weekTitle(int weekNumber, CourseLength length) {
  if (length == CourseLength.thirtyDays) {
    return switch (weekNumber) {
      1 => 'Week 1: Foundation',
      2 => 'Week 2: Build stamina',
      3 => 'Week 3: Increase intensity',
      _ => 'Week 4: Challenge week',
    };
  }

  if (weekNumber <= 4) return 'Week $weekNumber: Foundation';
  if (weekNumber <= 8) return 'Week $weekNumber: Progression';
  if (weekNumber <= 12) return 'Week $weekNumber: Transformation';
  return 'Week 13: Final 90-day challenge';
}

String _progressedExerciseName(
  String day,
  int weekNumber,
  CourseLength length,
) {
  if (_isRestDay(day)) return day;

  if (length == CourseLength.thirtyDays) {
    return switch (weekNumber) {
      1 => day,
      2 => '$day + stamina round',
      3 => '$day + intensity boost',
      _ => '$day challenge',
    };
  }

  return switch (weekNumber) {
    1 => day,
    2 => '$day + form focus',
    3 => '$day + extra round',
    4 => '$day weekly challenge',
    5 => '$day + strength upgrade',
    6 => '$day + endurance upgrade',
    7 => '$day + shorter rest',
    8 => '$day progression test',
    9 => '$day + advanced round',
    10 => '$day + power finisher',
    11 => '$day + transformation push',
    12 => '$day peak challenge',
    _ => '$day final challenge',
  };
}

bool _isRestDay(String day) {
  return day.toLowerCase().contains('rest');
}
