import 'package:flutter_test/flutter_test.dart';
import 'package:homefit_trainer/app.dart';

void main() {
  testWidgets('splash opens the login flow', (tester) async {
    await tester.pumpWidget(const HomeFitApp());

    expect(find.text('TRAIN • TRACK • TRANSFORM'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1700));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to HomeFit'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
  });

  testWidgets('login validates required credentials', (tester) async {
    await tester.pumpWidget(const HomeFitApp());
    await tester.pump(const Duration(milliseconds: 1700));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log in'));
    await tester.pump();

    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(
      find.text('Password must contain at least 6 characters'),
      findsOneWidget,
    );
  });
}
