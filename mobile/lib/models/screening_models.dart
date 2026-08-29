import 'dart:convert';

class LanguageItem {
  final String code;
  final String native;
  final String name;

  const LanguageItem({
    required this.code,
    required this.native,
    required this.name,
  });
}

const List<LanguageItem> kAppLanguages = [
  LanguageItem(code: 'hi', native: 'हिन्दी', name: 'Hindi'),
  LanguageItem(code: 'bn', native: 'বাংলা', name: 'Bengali'),
  LanguageItem(code: 'mr', native: 'मराठी', name: 'Marathi'),
  LanguageItem(code: 'ta', native: 'தமிழ்', name: 'Tamil'),
  LanguageItem(code: 'te', native: 'తెలుగు', name: 'Telugu'),
  LanguageItem(code: 'en', native: 'English', name: 'English'),
  LanguageItem(code: 'gu', native: 'ગુજરાતી', name: 'Gujarati'),
  LanguageItem(code: 'kn', native: 'ಕನ್ನಡ', name: 'Kannada'),
  LanguageItem(code: 'ml', native: 'മലയാളം', name: 'Malayalam'),
];

enum ScreeningRisk { low, elevated, uncertain }

class AcousticBiomarkers {
  final double speechRateWpm;
  final double pausePatternRatio;
  final double pitchVariationHz;
  final double jitterPercent;
  final double shimmerDb;
  final double hnrDb;

  AcousticBiomarkers({
    required this.speechRateWpm,
    required this.pausePatternRatio,
    required this.pitchVariationHz,
    required this.jitterPercent,
    required this.shimmerDb,
    required this.hnrDb,
  });

  Map<String, dynamic> toMap() => {
    'speechRateWpm': speechRateWpm,
    'pausePatternRatio': pausePatternRatio,
    'pitchVariationHz': pitchVariationHz,
    'jitterPercent': jitterPercent,
    'shimmerDb': shimmerDb,
    'hnrDb': hnrDb,
  };

  factory AcousticBiomarkers.fromMap(Map<String, dynamic> map) => AcousticBiomarkers(
    speechRateWpm: (map['speechRateWpm'] as num?)?.toDouble() ?? 70.0,
    pausePatternRatio: (map['pausePatternRatio'] as num?)?.toDouble() ?? 40.0,
    pitchVariationHz: (map['pitchVariationHz'] as num?)?.toDouble() ?? 75.0,
    jitterPercent: (map['jitterPercent'] as num?)?.toDouble() ?? 3.0,
    shimmerDb: (map['shimmerDb'] as num?)?.toDouble() ?? 4.0,
    hnrDb: (map['hnrDb'] as num?)?.toDouble() ?? 22.0,
  );
}

class ShapFactor {
  final String feature;
  final double weight;

  ShapFactor({required this.feature, required this.weight});

  Map<String, dynamic> toMap() => {'feature': feature, 'weight': weight};
  factory ShapFactor.fromMap(Map<String, dynamic> map) => ShapFactor(
    feature: map['feature'] ?? '',
    weight: (map['weight'] as num?)?.toDouble() ?? 0.0,
  );
}

class MLInferenceResult {
  final ScreeningRisk risk;
  final double confidenceScore;
  final double classicalRiskScore;
  final double quantumRiskScore;
  final List<ShapFactor> shapFactors;

  MLInferenceResult({
    required this.risk,
    required this.confidenceScore,
    required this.classicalRiskScore,
    required this.quantumRiskScore,
    required this.shapFactors,
  });

  Map<String, dynamic> toMap() => {
    'risk': risk.name,
    'confidenceScore': confidenceScore,
    'classicalRiskScore': classicalRiskScore,
    'quantumRiskScore': quantumRiskScore,
    'shapFactors': shapFactors.map((s) => s.toMap()).toList(),
  };

  factory MLInferenceResult.fromMap(Map<String, dynamic> map) => MLInferenceResult(
    risk: ScreeningRisk.values.firstWhere((e) => e.name == map['risk'], orElse: () => ScreeningRisk.elevated),
    confidenceScore: (map['confidenceScore'] as num?)?.toDouble() ?? 0.88,
    classicalRiskScore: (map['classicalRiskScore'] as num?)?.toDouble() ?? 0.84,
    quantumRiskScore: (map['quantumRiskScore'] as num?)?.toDouble() ?? 0.89,
    shapFactors: (map['shapFactors'] as List?)?.map((s) => ShapFactor.fromMap(s)).toList() ?? [],
  );
}

class ScreeningSession {
  final String id;
  final String patientName;
  final int patientAge;
  final String language;
  final bool assistedMode;
  final DateTime createdAt;
  final int durationSeconds;
  final AcousticBiomarkers biomarkers;
  final MLInferenceResult mlResult;
  final bool synced;
  final String? notes;

  ScreeningSession({
    required this.id,
    required this.patientName,
    required this.patientAge,
    required this.language,
    required this.assistedMode,
    required this.createdAt,
    required this.durationSeconds,
    required this.biomarkers,
    required this.mlResult,
    this.synced = true,
    this.notes,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'patientName': patientName,
    'patientAge': patientAge,
    'language': language,
    'assistedMode': assistedMode,
    'createdAt': createdAt.toIso8601String(),
    'durationSeconds': durationSeconds,
    'biomarkers': biomarkers.toMap(),
    'mlResult': mlResult.toMap(),
    'synced': synced,
    'notes': notes,
  };

  factory ScreeningSession.fromMap(Map<String, dynamic> map) => ScreeningSession(
    id: map['id'] ?? '',
    patientName: map['patientName'] ?? 'Patient',
    patientAge: map['patientAge'] ?? 70,
    language: map['language'] ?? 'hi',
    assistedMode: map['assistedMode'] ?? false,
    createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    durationSeconds: map['durationSeconds'] ?? 200,
    biomarkers: AcousticBiomarkers.fromMap(map['biomarkers'] ?? {}),
    mlResult: MLInferenceResult.fromMap(map['mlResult'] ?? {}),
    synced: map['synced'] ?? true,
    notes: map['notes'],
  );

  String toJson() => json.encode(toMap());
  factory ScreeningSession.fromJson(String source) => ScreeningSession.fromMap(json.decode(source));
}
