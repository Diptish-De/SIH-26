import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/screening_models.dart';

class StorageService {
  static const String _keyScreenings = 'swarsanket_screenings_v1';
  static const String _keyOfflineQueue = 'swarsanket_offline_queue_v1';

  static Future<void> saveScreening(ScreeningSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getScreenings();
    list.insert(0, session);
    final jsonList = list.map((s) => s.toMap()).toList();
    await prefs.setString(_keyScreenings, json.encode(jsonList));

    if (!session.synced) {
      await addToOfflineQueue(session.id);
    }
  }

  static Future<List<ScreeningSession>> getScreenings() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyScreenings);
    if (data == null) {
      return _getSeedScreenings();
    }
    try {
      final List decoded = json.decode(data);
      return decoded.map((m) => ScreeningSession.fromMap(m)).toList();
    } catch (_) {
      return _getSeedScreenings();
    }
  }

  static Future<void> addToOfflineQueue(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    final queue = prefs.getStringList(_keyOfflineQueue) ?? [];
    if (!queue.contains(sessionId)) {
      queue.add(sessionId);
      await prefs.setStringList(_keyOfflineQueue, queue);
    }
  }

  static Future<List<String>> getOfflineQueue() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyOfflineQueue) ?? [];
  }

  static Future<void> clearOfflineQueue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyOfflineQueue, []);
  }

  static List<ScreeningSession> _getSeedScreenings() {
    return [
      ScreeningSession(
        id: 'sc_20260828_01',
        patientName: 'Rama Devi',
        patientAge: 72,
        language: 'hi',
        assistedMode: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        durationSeconds: 240,
        biomarkers: AcousticBiomarkers(
          speechRateWpm: 68.0,
          pausePatternRatio: 45.0,
          pitchVariationHz: 72.0,
          jitterPercent: 3.2,
          shimmerDb: 4.1,
          hnrDb: 21.0,
        ),
        mlResult: MLInferenceResult(
          risk: ScreeningRisk.elevated,
          confidenceScore: 0.88,
          classicalRiskScore: 0.84,
          quantumRiskScore: 0.89,
          shapFactors: [
            ShapFactor(feature: 'Extended pause duration (>1.2s)', weight: 38.0),
            ShapFactor(feature: 'Vocal pitch jitter (3.2%)', weight: 30.0),
            ShapFactor(feature: 'Phonetic transition delay', weight: 22.0),
          ],
        ),
        synced: true,
      ),
      ScreeningSession(
        id: 'sc_20260815_02',
        patientName: 'Suresh Kumar',
        patientAge: 68,
        language: 'hi',
        assistedMode: false,
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
        durationSeconds: 210,
        biomarkers: AcousticBiomarkers(
          speechRateWpm: 92.0,
          pausePatternRatio: 22.0,
          pitchVariationHz: 88.0,
          jitterPercent: 1.1,
          shimmerDb: 2.2,
          hnrDb: 28.5,
        ),
        mlResult: MLInferenceResult(
          risk: ScreeningRisk.low,
          confidenceScore: 0.94,
          classicalRiskScore: 0.12,
          quantumRiskScore: 0.10,
          shapFactors: [],
        ),
        synced: true,
      ),
    ];
  }
}
