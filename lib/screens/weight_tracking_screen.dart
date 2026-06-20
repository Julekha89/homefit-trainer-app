import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/health_models.dart';
import '../services/firebase_service.dart';
import '../services/firestore_service.dart';

class WeightTrackingScreen extends StatefulWidget {
  const WeightTrackingScreen({super.key});

  @override
  State<WeightTrackingScreen> createState() => _WeightTrackingScreenState();
}

class _WeightTrackingScreenState extends State<WeightTrackingScreen> {
  double _weight = 70;
  bool _saving = false;

  String get _userId => FirebaseService.instance.isConfigured
      ? FirebaseAuth.instance.currentUser?.uid ?? 'demo-user'
      : 'demo-user';

  Future<void> _save() async {
    setState(() => _saving = true);
    await FirestoreService.instance.addWeight(
      _userId,
      WeightEntry(weightKg: _weight, recordedAt: DateTime.now()),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          FirestoreService.instance.isAvailable
              ? 'Weight saved to Firestore.'
              : 'Demo mode: connect Firebase to sync weight history.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weight Tracking')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.navy, Color(0xFF174558)],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              children: [
                const Text(
                  'CURRENT WEIGHT',
                  style: TextStyle(
                    color: AppColors.lime,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${_weight.toStringAsFixed(1)} kg',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Log today\'s weight',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  Slider(
                    value: _weight,
                    min: 35,
                    max: 180,
                    divisions: 290,
                    label: _weight.toStringAsFixed(1),
                    onChanged: (value) => setState(() => _weight = value),
                  ),
                  FilledButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: const Icon(Icons.cloud_upload_outlined),
                    label: Text(_saving ? 'Saving...' : 'Save weight'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Recent entries',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          StreamBuilder<List<WeightEntry>>(
            stream: FirestoreService.instance.watchWeights(_userId),
            builder: (context, snapshot) {
              final entries = snapshot.data ?? const <WeightEntry>[];
              if (entries.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(22),
                    child: Text(
                      'No synced entries yet. Your weight trend will appear here.',
                      style: TextStyle(color: AppColors.muted),
                    ),
                  ),
                );
              }
              return Column(
                children: entries
                    .map(
                      (entry) => Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: const Icon(
                            Icons.monitor_weight_outlined,
                            color: AppColors.cyan,
                          ),
                          title: Text(
                            '${entry.weightKg.toStringAsFixed(1)} kg',
                          ),
                          subtitle: Text(
                            '${entry.recordedAt.day}/${entry.recordedAt.month}/${entry.recordedAt.year}',
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
