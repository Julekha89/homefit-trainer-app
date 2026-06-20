import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/health_models.dart';
import 'firebase_service.dart';

class FirestoreService {
  FirestoreService._();

  static final instance = FirestoreService._();

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  bool get isAvailable => FirebaseService.instance.isConfigured;

  Future<void> saveProfile(UserProfile profile) async {
    if (!isAvailable) return;
    await _db
        .collection('users')
        .doc(profile.id)
        .set(profile.toMap(), SetOptions(merge: true));
  }

  Stream<UserProfile?> watchProfile(String userId) {
    if (!isAvailable) return Stream.value(null);
    return _db.collection('users').doc(userId).snapshots().map((snapshot) {
      final data = snapshot.data();
      return data == null ? null : UserProfile.fromMap(snapshot.id, data);
    });
  }

  Future<void> addWeight(String userId, WeightEntry entry) async {
    if (!isAvailable) return;
    final user = _db.collection('users').doc(userId);
    final batch = _db.batch();
    batch.set(user.collection('weights').doc(), entry.toMap());
    batch.set(user, {
      'currentWeightKg': entry.weightKg,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await batch.commit();
  }

  Stream<List<WeightEntry>> watchWeights(String userId) {
    if (!isAvailable) return Stream.value(const []);
    return _db
        .collection('users')
        .doc(userId)
        .collection('weights')
        .orderBy('recordedAt', descending: true)
        .limit(30)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => WeightEntry.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<void> recordWorkout(String userId, WorkoutHistoryEntry workout) async {
    if (!isAvailable) return;
    final user = _db.collection('users').doc(userId);
    await user.collection('workoutHistory').add(workout.toMap());
    await _updateDailyStreak(user);
  }

  Stream<List<WorkoutHistoryEntry>> watchWorkoutHistory(String userId) {
    if (!isAvailable) return Stream.value(const []);
    return _db
        .collection('users')
        .doc(userId)
        .collection('workoutHistory')
        .orderBy('completedAt', descending: true)
        .limit(50)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => WorkoutHistoryEntry.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<void> _updateDailyStreak(
    DocumentReference<Map<String, dynamic>> user,
  ) async {
    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(user);
      final data = snapshot.data() ?? <String, dynamic>{};
      final lastWorkout = (data['lastWorkoutDate'] as Timestamp?)?.toDate();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final previousDay = today.subtract(const Duration(days: 1));
      final lastDay = lastWorkout == null
          ? null
          : DateTime(lastWorkout.year, lastWorkout.month, lastWorkout.day);
      final current = (data['dailyStreak'] as num?)?.toInt() ?? 0;
      final next = lastDay == today
          ? current
          : lastDay == previousDay
          ? current + 1
          : 1;

      transaction.set(user, {
        'dailyStreak': next,
        'lastWorkoutDate': Timestamp.fromDate(now),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
  }
}
