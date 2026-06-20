import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'screens/splash_screen.dart';

class HomeFitApp extends StatelessWidget {
  const HomeFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomeFit Trainer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}
