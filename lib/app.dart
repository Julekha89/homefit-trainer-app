import 'package:flutter/material.dart';

import 'controllers/app_controller.dart';
import 'core/app_theme.dart';
import 'screens/splash_screen.dart';

class HomeFitApp extends StatelessWidget {
  const HomeFitApp({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => AppControllerScope(
        controller: controller,
        child: MaterialApp(
          title: 'HomeFit Trainer',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: controller.themeMode,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
