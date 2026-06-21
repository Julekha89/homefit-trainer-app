import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  FirebaseService._();

  static final instance = FirebaseService._();

  bool _configured = false;
  Object? _initializationError;

  bool get isConfigured => _configured;
  Object? get initializationError => _initializationError;

  Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      _configured = true;
    } catch (error) {
      _initializationError = error;
      _configured = false;
    }
  }
}
