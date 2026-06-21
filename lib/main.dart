import 'package:flutter/material.dart';

import 'app.dart';
import 'controllers/app_controller.dart';
import 'services/firebase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.instance.initialize();
  final controller = await AppController.create();
  runApp(HomeFitApp(controller: controller));
}
