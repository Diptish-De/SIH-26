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
  String _currentScreen = 'home';
  String _selectedLanguage = 'en';
  final String _userName = 'Friend';
  String _selectedPatient = 'Rama Devi';
  bool _isOnline = true;
  bool _hasError = false;
  bool _hasPreviousCheck = true;

  final AudioRecorderService _audioRecorder = AudioRecorderService();

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  void _navigateTo(String screen) {
    setState(() => _currentScreen = screen);
  }

  void _showReminderModal() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.notifications_active, color: AppColors.purple),
            const SizedBox(width: 8),
            Text('Daily Voice Reminder', style: AppTheme.theme.textTheme.titleMedium),
          ],
        ),
        content: const Text(
          'It is time for your weekly 3-minute voice check. Regular screenings help track vocal biomarker trends.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _navigateTo('voiceIntro');
            },
            child: const Text('Start Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenContent() {
    switch (_currentScreen) {
      case 'home':
        return HomeScreen(
          userName: _userName,
          language: _selectedLanguage,
          hasPreviousCheck: _hasPreviousCheck,
          hasError: _hasError,
          onStartCheck: () => _navigateTo('voiceIntro'),
          onHistory: () => _navigateTo('doctorDash'),
          onHelp: () => _navigateTo('instruction'),
          onCaregiver: () => _navigateTo('doctorPatient'),
          onProfile: () => _navigateTo('doctorDash'),
          onSettings: () => _navigateTo('home'),
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
              : 'Tell us about something you enjoy doing.',
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

      default:
        return HomeScreen(
          userName: _userName,
          language: _selectedLanguage,
          onStartCheck: () => _navigateTo('voiceIntro'),
          onHistory: () => _navigateTo('doctorDash'),
          onHelp: () => _navigateTo('instruction'),
          onCaregiver: () => _navigateTo('doctorPatient'),
          onProfile: () => _navigateTo('doctorDash'),
          onSettings: () => _navigateTo('home'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FigmaPhoneFrame(
      currentScreen: _currentScreen,
      isOnline: _isOnline,
      onToggleOnline: () => setState(() => _isOnline = !_isOnline),
      onDoctorView: () => _navigateTo('doctorDash'),
      onReminder: _showReminderModal,
      onErrorState: () => setState(() => _hasError = !_hasError),
      onEmptyState: () => setState(() => _hasPreviousCheck = !_hasPreviousCheck),
      onRestart: () {
        setState(() {
          _currentScreen = 'home';
          _hasError = false;
          _hasPreviousCheck = true;
        });
      },
      child: _buildScreenContent(),
    );
  }
}
