import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'models/screening_models.dart';
import 'services/tts_service.dart';
import 'services/audio_service.dart';
import 'services/storage_service.dart';
import 'screens/splash_screen.dart';
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
  int _activeTabIndex = 0;
  String _currentScreen = 'splash';
  String _selectedLanguage = 'en';
  final String _userName = 'Rama Devi';
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
              _navigateTo('intro');
            },
            child: const Text('Start Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenContent() {
    switch (_currentScreen) {
      case 'splash':
        return SplashScreen(
          onFinish: () => _navigateTo('tabs'),
        );

      // ─── Voice Check Intro ─────────────────────────────────────────
      case 'intro':
        return VoiceCheckIntroScreen(
          language: _selectedLanguage,
          onBegin: () => _navigateTo('task1'),
          onAssisted: () => _navigateTo('task1'),
          onBack: () => _navigateTo('tabs'),
        );

      // ─── Task 1 of 3: Picture Description ─────────────────────────
      case 'task1':
        return PictureDescriptionScreen(
          language: _selectedLanguage,
          onStartSpeaking: () => _navigateTo('ready1'),
          onBack: () => _navigateTo('intro'),
          onClose: () => _navigateTo('tabs'),
        );

      case 'ready1':
        return ReadyToSpeakScreen(
          stepIndex: 1,
          onStartRecording: () => _navigateTo('rec1'),
          onBack: () => _navigateTo('task1'),
          onClose: () => _navigateTo('tabs'),
        );

      case 'rec1':
        return ActiveRecordingScreen(
          recorder: _audioRecorder,
          stepIndex: 1,
          onFinish: () => _navigateTo('quality1'),
          onBack: () => _navigateTo('ready1'),
          onClose: () => _navigateTo('tabs'),
        );

      case 'quality1':
        return VoiceQualityCheckScreen(
          onContinue: () => _navigateTo('review1'),
        );

      case 'review1':
        return RecordingReviewScreen(
          onContinue: () => _navigateTo('task2_intro'),
          onRecordAgain: () => _navigateTo('ready1'),
        );

      // ─── Task 2 of 3: Memory Recall ──────────────────────────────
      case 'task2_intro':
        return MemoryRecallIntroScreen(
          language: _selectedLanguage,
          onContinue: () => _navigateTo('task2_prompt'),
          onBack: () => _navigateTo('review1'),
          onClose: () => _navigateTo('tabs'),
        );

      case 'task2_prompt':
        return MemoryRecallPromptScreen(
          language: _selectedLanguage,
          onStartSpeaking: () => _navigateTo('ready2'),
          onListenAgain: () => _navigateTo('task2_intro'),
          onBack: () => _navigateTo('task2_intro'),
          onClose: () => _navigateTo('tabs'),
        );

      case 'ready2':
        return ReadyToSpeakScreen(
          stepIndex: 2,
          onStartRecording: () => _navigateTo('rec2'),
          onBack: () => _navigateTo('task2_prompt'),
          onClose: () => _navigateTo('tabs'),
        );

      case 'rec2':
        return ActiveRecordingScreen(
          recorder: _audioRecorder,
          stepIndex: 2,
          onFinish: () => _navigateTo('quality2'),
          onBack: () => _navigateTo('ready2'),
          onClose: () => _navigateTo('tabs'),
        );

      case 'quality2':
        return VoiceQualityCheckScreen(
          onContinue: () => _navigateTo('review2'),
        );

      case 'review2':
        return RecordingReviewScreen(
          onContinue: () => _navigateTo('task3'),
          onRecordAgain: () => _navigateTo('ready2'),
        );

      // ─── Task 3 of 3: Conversational Task ─────────────────────────
      case 'task3':
        return ConversationalTaskScreen(
          language: _selectedLanguage,
          onStartSpeaking: () => _navigateTo('ready3'),
          onBack: () => _navigateTo('review2'),
          onClose: () => _navigateTo('tabs'),
        );

      case 'ready3':
        return ReadyToSpeakScreen(
          stepIndex: 3,
          onStartRecording: () => _navigateTo('rec3'),
          onBack: () => _navigateTo('task3'),
          onClose: () => _navigateTo('tabs'),
        );

      case 'rec3':
        return ActiveRecordingScreen(
          recorder: _audioRecorder,
          stepIndex: 3,
          onFinish: () => _navigateTo('quality3'),
          onBack: () => _navigateTo('ready3'),
          onClose: () => _navigateTo('tabs'),
        );

      case 'quality3':
        return VoiceQualityCheckScreen(
          onContinue: () => _navigateTo('review3'),
        );

      case 'review3':
        return RecordingReviewScreen(
          onContinue: () => _navigateTo('completion'),
          onRecordAgain: () => _navigateTo('ready3'),
        );

      // ─── Completion & ML Analysis ─────────────────────────────────
      case 'completion':
        return CompletionScreen(
          onComplete: () => _navigateTo('processing'),
        );

      case 'processing':
        return AnalyzingVoiceScreen(
          onComplete: () async {
            if (_hasError) {
              _navigateTo('tryAgain');
              return;
            }

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
                  ShapFactor(feature: 'Extended pause duration (>1.2s)', weight: 38.0),
                  ShapFactor(feature: 'Vocal pitch jitter (3.2%)', weight: 30.0),
                ],
              ),
            );
            await StorageService.saveScreening(session);
            _navigateTo('result');
          },
        );

      // ─── Quality Error State: Try Again ───────────────────────────
      case 'tryAgain':
        return TryAgainErrorScreen(
          onTryAgain: () => _navigateTo('intro'),
          onHealthcare: () => _navigateTo('doctorPatient'),
        );

      // ─── Result Screen ────────────────────────────────────────────
      case 'result':
        return ScreeningResultScreen(
          risk: ScreeningRisk.elevated,
          onDone: () {
            setState(() => _activeTabIndex = 0);
            _navigateTo('tabs');
          },
          onDetails: () => _navigateTo('doctorPatient'),
        );

      // ─── Doctor Clinical Dashboard & Longitudinal Trends ──────────
      case 'doctorDash':
        return DoctorDashboardScreen(
          onBack: () => _navigateTo('tabs'),
          onSelectPatient: (name) {
            setState(() => _selectedPatient = name);
            _navigateTo('doctorPatient');
          },
        );

      case 'doctorPatient':
        return DoctorPatientDetailScreen(
          patientName: _selectedPatient,
          onBack: () => _navigateTo('tabs'),
        );

      // ─── Main Persistent Tabs ─────────────────────────────────────
      case 'tabs':
      default:
        return MainTabScaffold(
          activeIndex: _activeTabIndex,
          onTabChange: (idx) => setState(() => _activeTabIndex = idx),
          userName: _userName,
          language: _selectedLanguage,
          hasPreviousCheck: _hasPreviousCheck,
          hasError: _hasError,
          onStartCheck: () => _navigateTo('intro'),
          onDoctorPatient: () => _navigateTo('doctorPatient'),
          onLanguageChanged: (lang) => setState(() => _selectedLanguage = lang),
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
          _activeTabIndex = 0;
          _currentScreen = 'splash';
          _hasError = false;
          _hasPreviousCheck = true;
        });
      },
      child: _buildScreenContent(),
    );
  }
}
