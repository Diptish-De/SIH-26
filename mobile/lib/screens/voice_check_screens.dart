import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/screening_models.dart';
import '../services/tts_service.dart';
import '../services/audio_service.dart';

// ─── 1. Voice Check Intro ─────────────────────────────────────────────────────

class VoiceIntroScreen extends StatelessWidget {
  final String language;
  final VoidCallback onStart;
  final VoidCallback onBack;

  const VoiceIntroScreen({
    super.key,
    required this.language,
    required this.onStart,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: onBack,
        ),
        title: Text('Voice Check', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.text)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Spacer(),
            Text(
              'Let\'s begin',
              style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.text),
            ),
            const SizedBox(height: 8),
            Text(
              'This is a short voice check. It takes about 3–5 minutes.',
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSans(fontSize: 14, color: AppColors.muted),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                _buildStepCard('01', 'Listen'),
                const SizedBox(width: 12),
                _buildStepCard('02', 'Speak'),
                const SizedBox(width: 12),
                _buildStepCard('03', 'Finish'),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => TtsService().speak('Let\'s begin. This is a short voice check.', language),
              icon: const Icon(Icons.volume_up, size: 18, color: AppColors.primaryDark),
              label: const Text('Listen (सुनें)', style: TextStyle(color: AppColors.primaryDark)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onStart,
                child: const Text('Begin Voice Check'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onStart,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Someone is helping me', style: TextStyle(color: AppColors.textSub)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(String number, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(number, style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 4),
            Text(label, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.text)),
          ],
        ),
      ),
    );
  }
}

// ─── 2. Instruction / Prompt Screen ───────────────────────────────────────────

class InstructionScreen extends StatelessWidget {
  final String prompt;
  final String language;
  final VoidCallback onStartSpeaking;
  final VoidCallback onBack;

  const InstructionScreen({
    super.key,
    required this.prompt,
    required this.language,
    required this.onStartSpeaking,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.text), onPressed: onBack),
        title: Text('Task 1 of 3', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.muted)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.volume_up, size: 40, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 24),
            Text('Listen to the question', style: GoogleFonts.notoSans(fontSize: 13, color: AppColors.muted)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4)),
                ],
              ),
              child: Text(
                prompt,
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSans(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.text),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => TtsService().speak(prompt, language),
              icon: const Icon(Icons.replay, size: 18, color: AppColors.primaryDark),
              label: const Text('Play Again', style: TextStyle(color: AppColors.primaryDark)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onStartSpeaking,
                child: const Text('Start Speaking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 3. Recording Screen ──────────────────────────────────────────────────────

class RecordingScreen extends StatefulWidget {
  final AudioRecorderService recorder;
  final VoidCallback onFinish;

  const RecordingScreen({
    super.key,
    required this.recorder,
    required this.onFinish,
  });

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  int _seconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startRecording();
  }

  void _startRecording() async {
    await widget.recorder.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && !widget.recorder.isPaused) {
        setState(() => _seconds++);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fmtTime = '${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Recording', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.text)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Animated Mic Button
            GestureDetector(
              onTap: () {
                if (widget.recorder.isPaused) {
                  widget.recorder.resume();
                } else {
                  widget.recorder.pause();
                }
                setState(() {});
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.danger,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.danger.withOpacity(0.35),
                      blurRadius: 28,
                      spreadRadius: 6,
                    ),
                  ],
                ),
                child: Icon(
                  widget.recorder.isPaused ? Icons.play_arrow : Icons.mic,
                  color: Colors.white,
                  size: 52,
                ),
              ),
            ),

            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text(
                    widget.recorder.isPaused ? 'Paused' : 'Recording Voice',
                    style: GoogleFonts.notoSans(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red.shade900),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              fmtTime,
              style: GoogleFonts.outfit(fontSize: 44, fontWeight: FontWeight.bold, color: AppColors.text),
            ),
            Text('Speak naturally… (स्वाभाविक रूप से बोलें)', style: GoogleFonts.notoSans(fontSize: 13, color: AppColors.muted)),

            const SizedBox(height: 32),

            // Animated Waveform Simulation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(20, (index) {
                final height = widget.recorder.isPaused
                    ? 8.0
                    : 10.0 + ((index * 7) % 36);
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 5,
                  height: height,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await widget.recorder.stop();
                  widget.onFinish();
                },
                child: const Text('Finish Recording'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 4. Processing Animation ──────────────────────────────────────────────────

class ProcessingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const ProcessingScreen({super.key, required this.onComplete});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 60), (timer) {
      if (mounted) {
        setState(() {
          _progress += 0.03;
          if (_progress >= 1.0) {
            timer.cancel();
            Future.delayed(const Duration(milliseconds: 300), widget.onComplete);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(Icons.auto_awesome, size: 52, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 28),
            Text(
              'Analyzing your voice…',
              style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.text),
            ),
            const SizedBox(height: 6),
            Text(
              'Dual-engine Classical & Quantum ML analysis',
              style: GoogleFonts.notoSans(fontSize: 12, color: AppColors.muted),
            ),
            const SizedBox(height: 32),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: _progress.clamp(0.0, 1.0),
                minHeight: 10,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${(_progress * 100).clamp(0, 100).toInt()}%',
              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 5. Screening Result ──────────────────────────────────────────────────────

class ScreeningResultScreen extends StatelessWidget {
  final ScreeningRisk risk;
  final VoidCallback onHome;
  final VoidCallback onDetails;

  const ScreeningResultScreen({
    super.key,
    required this.risk,
    required this.onHome,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    final isElevated = risk == ScreeningRisk.elevated;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: isElevated ? AppColors.warningBg : AppColors.successBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isElevated ? Icons.info_outline : Icons.check_circle_outline,
                  size: 48,
                  color: isElevated ? AppColors.warning : AppColors.success,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isElevated ? AppColors.warningBg : AppColors.successBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isElevated ? 'Further Evaluation Recommended' : 'No Immediate Concern Detected',
                  style: TextStyle(
                    color: isElevated ? AppColors.warning : AppColors.success,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Voice Check Complete',
                style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.text),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  isElevated
                      ? 'The screening found some speech and acoustic patterns that may benefit from professional assessment.'
                      : 'This screening did not identify voice biomarker patterns that require immediate follow-up.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSans(fontSize: 13, color: AppColors.textSub, height: 1.5),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'This screening does not replace a medical diagnosis.',
                style: GoogleFonts.notoSans(fontSize: 11, color: AppColors.muted),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onHome,
                  child: const Text('Done'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onDetails,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('View Screening Details', style: TextStyle(color: AppColors.textSub)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
