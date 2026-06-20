import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';

import '../models/workout.dart';

class VoiceCoachService {
  VoiceCoachService._();

  static final instance = VoiceCoachService._();
  final FlutterTts _tts = FlutterTts();

  Future<void> initialize() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.48);
    await _tts.setPitch(1.0);
    await _tts.awaitSpeakCompletion(true);
  }

  Future<void> speak(String message) async {
    await _tts.stop();
    await _tts.speak(message);
  }

  Future<void> announceExercise(Exercise exercise) async {
    final instructions = exercise.instructions.join(' ');
    await speak('${exercise.name}. $instructions');
  }

  Future<void> countdown({int from = 3}) async {
    for (var value = from; value > 0; value--) {
      await speak('$value');
      await Future<void>.delayed(const Duration(milliseconds: 250));
    }
    await speak('Go');
  }

  Future<void> stop() => _tts.stop();
}
