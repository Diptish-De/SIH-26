import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'models/screening_models.dart';
import 'services/tts_service.dart';
import 'services/audio_service.dart';
import 'services/storage_service.dart';
import 'screens/app_screens.dart';
import 'screens/voice_check_screens.dart';
import 'screens/doctor_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TtsService().init();
  runApp(const SwarSanketApp());
}

class SwarSanketApp extends StatelessWidget {
  const SwarSanketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwarSanket',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const MainNavigationController(),
    );
  }
}

class MainNavigationController extends StatefulWidget {
  const MainNavigationController({super.key});

  @override
  State<MainNavigationController> createState() => _MainNavigationControllerState();
}

class _MainNavigationControllerState extends State<MainNavigationController> {
  String _currentScreen = 'welcome';
  String _selectedLanguage = 'hi';
  String _userName = 'Rama Devi';
  String _selectedPatient = 'Rama Devi';

  final AudioRecorderService _audioRecorder = AudioRecorderService();

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  void _navigateTo(String screen) {
    setState(() => _currentScreen = screen);
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentScreen) {
      case 'language':
        return LanguageSelectScreen(
          selectedLang: _selectedLanguage,
          onSelect: (lang) => setState(() => _selectedLanguage = lang),
          onContinue: () => _navigateTo('home'),
        );

      case 'welcome':
        return WelcomeScreen(
          language: _selectedLanguage,
          onStart: () => _navigateTo('voiceIntro'),
        );

      case 'voiceIntro':
        return VoiceIntroScreen(
          language: _selectedLanguage,
          onStart: () => _navigateTo('instruction'),
          onBack: () => _navigateTo('home'),
        );

      case 'instruction':
        return InstructionScreen(
          prompt: _selectedLanguage == 'hi'
              ? 'हमें अपने दिन के बारे में बताइए।'
              : 'Tell us about your day.',
          language: _selectedLanguage,
          onStartSpeaking: () => _navigateTo('recording'),
          onBack: () => _navigateTo('voiceIntro'),
        );

      case 'recording':
        return RecordingScreen(
          recorder: _audioRecorder,
          onFinish: () => _navigateTo('processing'),
        );

      case 'processing':
        return ProcessingScreen(
          onComplete: () async {
            // Save mock session
            final session = ScreeningSession(
              id: 'sc_${DateTime.now().millisecondsSinceEpoch}',
              patientName: _userName,
              patientAge: 72,
              language: _selectedLanguage,
              assistedMode: false,
              createdAt: DateTime.now(),
              durationSeconds: 220,
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
                  ShapFactor(feature: 'Extended pause duration', weight: 38.0),
                ],
              ),
            );
            await StorageService.saveScreening(session);
            _navigateTo('result');
          },
        );

      case 'result':
        return ScreeningResultScreen(
          risk: ScreeningRisk.elevated,
          onHome: () => _navigateTo('home'),
          onDetails: () => _navigateTo('doctorPatient'),
        );

      case 'doctorDash':
        return DoctorDashboardScreen(
          onBack: () => _navigateTo('home'),
          onSelectPatient: (name) {
            setState(() => _selectedPatient = name);
            _navigateTo('doctorPatient');
          },
        );

      case 'doctorPatient':
        return DoctorPatientDetailScreen(
          patientName: _selectedPatient,
          onBack: () => _navigateTo('doctorDash'),
        );

      case 'home':
      default:
        return HomeScreen(
          userName: _userName,
          language: _selectedLanguage,
          onStartCheck: () => _navigateTo('voiceIntro'),
          onDoctorDash: () => _navigateTo('doctorDash'),
          onHistory: () => _navigateTo('doctorDash'),
          onCaregiver: () => _navigateTo('voiceIntro'),
          onHealthWorker: () => _navigateTo('doctorDash'),
          onHelp: () => _navigateTo('language'),
          onSettings: () => _navigateTo('language'),
        );
    }
  }
}
