import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homefit_trainer/app.dart';
import 'package:homefit_trainer/controllers/app_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('splash opens the login flow', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final controller = await AppController.create();
    await tester.pumpWidget(HomeFitApp(controller: controller));

    expect(find.text('TRAIN • TRACK • TRANSFORM'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1700));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to HomeFit'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
  });

  testWidgets('login validates required credentials', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final controller = await AppController.create();
    await tester.pumpWidget(HomeFitApp(controller: controller));
    await tester.pump(const Duration(milliseconds: 1700));
    await tester.pumpAndSettle();

    final loginButton = find.byKey(const Key('login-button'));
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pump();

    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(
      find.text('Password must contain at least 6 characters'),
      findsOneWidget,
    );
  });
}
