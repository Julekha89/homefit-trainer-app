import 'package:flutter_test/flutter_test.dart';
import 'package:homefit_trainer/data/course_data.dart';
import 'package:homefit_trainer/models/workout.dart';

void main() {
  test('every profile gets 30-day and 90-day courses', () {
    for (final gender in Gender.values) {
      for (final goal in FitnessGoal.values) {
        for (final level in FitnessLevel.values) {
          final courses = recommendedCoursePlans(
            gender: gender,
            goal: goal,
            level: level,
          );

          expect(courses, hasLength(2));
          expect(
            courses.map((course) => course.length),
            containsAll([CourseLength.thirtyDays, CourseLength.ninetyDays]),
          );
          expect(courses.every((course) => course.gender == gender), isTrue);
          expect(courses.every((course) => course.goal == goal), isTrue);
          expect(courses.every((course) => course.level == level), isTrue);
          expect(courses.every((course) => course.phases.isNotEmpty), isTrue);
          expect(
            courses.every(
              (course) => course.weeklySchedule.first.days.length == 7,
            ),
            isTrue,
          );
        }
      }
    }
  });

  test('ninety-day advanced plan uses the highest weekly frequency', () {
    final courses = recommendedCoursePlans(
      gender: Gender.male,
      goal: FitnessGoal.buildMuscle,
      level: FitnessLevel.advanced,
    );
    final ninetyDay = courses.firstWhere(
      (course) => course.length == CourseLength.ninetyDays,
    );

    expect(ninetyDay.workoutDaysPerWeek, 6);
    expect(ninetyDay.title, '90-Day Build muscle Advanced');
  });
}
