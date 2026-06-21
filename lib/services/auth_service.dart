import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_service.dart';

class AuthResult {
  const AuthResult({
    required this.success,
    required this.isDemo,
    this.user,
    this.message,
  });

  final bool success;
  final bool isDemo;
  final User? user;
  final String? message;
}

class AuthService {
  AuthService._();

  static final instance = AuthService._();
  bool _googleInitialized = false;

  Future<AuthResult> signInWithEmail(String email, String password) async {
    if (!FirebaseService.instance.isConfigured) {
      return const AuthResult(success: true, isDemo: true);
    }

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return AuthResult(success: true, isDemo: false, user: credential.user);
    } on FirebaseAuthException catch (error) {
      return AuthResult(
        success: false,
        isDemo: false,
        message: _friendlyMessage(error),
      );
    }
  }

  Future<AuthResult> createAccount(String email, String password) async {
    if (!FirebaseService.instance.isConfigured) {
      return const AuthResult(success: true, isDemo: true);
    }

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );
      return AuthResult(success: true, isDemo: false, user: credential.user);
    } on FirebaseAuthException catch (error) {
      return AuthResult(
        success: false,
        isDemo: false,
        message: _friendlyMessage(error),
      );
    }
  }

  Future<AuthResult> signInWithGoogle() async {
    if (!FirebaseService.instance.isConfigured) {
      return const AuthResult(success: true, isDemo: true);
    }

    try {
      if (kIsWeb) {
        final result = await FirebaseAuth.instance.signInWithPopup(
          GoogleAuthProvider(),
        );
        return AuthResult(success: true, isDemo: false, user: result.user);
      }
      final signIn = GoogleSignIn.instance;
      if (!_googleInitialized) {
        await signIn.initialize();
        _googleInitialized = true;
      }
      final account = await signIn.authenticate();
      final token = account.authentication.idToken;
      final credential = GoogleAuthProvider.credential(idToken: token);
      final result = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      return AuthResult(success: true, isDemo: false, user: result.user);
    } on FirebaseAuthException catch (error) {
      return AuthResult(
        success: false,
        isDemo: false,
        message: _friendlyMessage(error),
      );
    } catch (error) {
      return AuthResult(
        success: false,
        isDemo: false,
        message: 'Google sign-in could not be completed.',
      );
    }
  }

  Future<void> signOut() async {
    if (!FirebaseService.instance.isConfigured) return;
    await FirebaseAuth.instance.signOut();
    if (_googleInitialized) await GoogleSignIn.instance.signOut();
  }

  String _friendlyMessage(FirebaseAuthException error) {
    return switch (error.code) {
      'invalid-credential' => 'Email or password is incorrect.',
      'user-not-found' => 'No account exists for this email.',
      'email-already-in-use' => 'An account already uses this email.',
      'weak-password' => 'Choose a stronger password.',
      'network-request-failed' => 'Check your internet connection.',
      _ => error.message ?? 'Authentication failed. Please try again.',
    };
  }
}
