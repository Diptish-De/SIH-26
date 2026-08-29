import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/screening_models.dart';
import '../services/tts_service.dart';
import '../services/audio_service.dart';

// ─── Step Indicator Dots (Figma: [ — ] [ • ] [ • ]) ───────────────────────────

class StepProgressHeader extends StatelessWidget {
  final int currentStep; // 1, 2, 3
  final VoidCallback onBack;
  final VoidCallback onClose;

  const StepProgressHeader({
    super.key,
    required this.currentStep,
    required this.onBack,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.text, size: 20),
            onPressed: onBack,
          ),
          Row(
            children: [
              _buildDot(1 == currentStep),
              const SizedBox(width: 6),
              _buildDot(2 == currentStep),
              const SizedBox(width: 6),
              _buildDot(3 == currentStep),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.text, size: 20),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: isActive ? 22 : 7,
      height: 7,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.border,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// ─── Task 1 of 3: Picture Description Screen ──────────────────────────────────

class PictureDescriptionScreen extends StatelessWidget {
  final String language;
  final VoidCallback onStartSpeaking;
  final VoidCallback onBack;
  final VoidCallback onClose;

  const PictureDescriptionScreen({
    super.key,
    required this.language,
    required this.onStartSpeaking,
    required this.onBack,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    const prompt = 'Tell us what you see in the picture.';

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            StepProgressHeader(currentStep: 1, onBack: onBack, onClose: onClose),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  children: [
                    Text(
                      'What do you see?',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      prompt,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSans(fontSize: 13, color: AppColors.muted),
                    ),
                    const SizedBox(height: 12),

                    // Listen Pill
                    InkWell(
                      onTap: () => TtsService().speak(prompt, language),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.volume_up, size: 16, color: AppColors.primaryDark),
                            const SizedBox(width: 6),
                            Text(
                              'Listen',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Illustrated Picture Card (House, Sun, Tree, Bicycle)
                    Container(
                      width: double.infinity,
                      height: 220,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE), // Sky blue
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: CustomPaint(
                          painter: CountrysideScenePainter(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Start Speaking Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onStartSpeaking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'Start Speaking',
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for Countryside Illustration matching Figma
class CountrysideScenePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Sun
    final sunPaint = Paint()..color = const Color(0xFFFDE047);
    final sunRayPaint = Paint()
      ..color = const Color(0xFFFACC15)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final sunCenter = Offset(w * 0.82, h * 0.25);
    canvas.drawCircle(sunCenter, 22, sunPaint);
    for (int i = 0; i < 8; i++) {
      final angle = i * (pi / 4);
      final p1 = Offset(sunCenter.dx + cos(angle) * 26, sunCenter.dy + sin(angle) * 26);
      final p2 = Offset(sunCenter.dx + cos(angle) * 34, sunCenter.dy + sin(angle) * 34);
      canvas.drawLine(p1, p2, sunRayPaint);
    }

    // 2. White Cloud
    final cloudPaint = Paint()..color = Colors.white.withValues(alpha: 0.85);
    canvas.drawOval(Rect.fromLTWH(w * 0.15, h * 0.12, 80, 32), cloudPaint);
    canvas.drawCircle(Offset(w * 0.28, h * 0.2), 20, cloudPaint);

    // 3. Birds in distance
    final birdPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawArc(Rect.fromLTWH(w * 0.45, h * 0.18, 12, 8), pi, pi, false, birdPaint);
    canvas.drawArc(Rect.fromLTWH(w * 0.48, h * 0.18, 12, 8), pi, pi, false, birdPaint);

    // 4. Green Ground
    final groundPaint = Paint()..color = const Color(0xFF86EFAC); // Grass green
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, h * 0.62, w, h * 0.38), const Radius.circular(0)),
      groundPaint,
    );

    // 5. House (Orange Roof & Body)
    final houseWall = Paint()..color = const Color(0xFFFED7AA);
    canvas.drawRect(Rect.fromLTWH(w * 0.12, h * 0.50, 70, 48), houseWall);

    final roofPath = Path()
      ..moveTo(w * 0.12 - 6, h * 0.50)
      ..lineTo(w * 0.12 + 35, h * 0.36)
      ..lineTo(w * 0.12 + 76, h * 0.50)
      ..close();
    final roofPaint = Paint()..color = const Color(0xFFFB923C);
    canvas.drawPath(roofPath, roofPaint);

    // House Window & Door
    final windowPaint = Paint()..color = const Color(0xFFBFDBFE);
    canvas.drawRect(Rect.fromLTWH(w * 0.15, h * 0.55, 14, 14), windowPaint);

    final doorPaint = Paint()..color = const Color(0xFFC084FC);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.23, h * 0.60, 16, 26), const Radius.circular(4)),
      doorPaint,
    );

    // 6. Tree
    final trunkPaint = Paint()..color = const Color(0xFF94A3B8)..strokeWidth = 6;
    canvas.drawLine(Offset(w * 0.52, h * 0.54), Offset(w * 0.52, h * 0.72), trunkPaint);

    final foliagePaint = Paint()..color = const Color(0xFF4ADE80);
    canvas.drawCircle(Offset(w * 0.52, h * 0.48), 24, foliagePaint);

    // 7. Bicycle Wheels
    final bikePaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(Offset(w * 0.72, h * 0.72), 12, bikePaint);
    canvas.drawCircle(Offset(w * 0.84, h * 0.72), 12, bikePaint);
    canvas.drawLine(Offset(w * 0.72, h * 0.72), Offset(w * 0.78, h * 0.65), bikePaint);
    canvas.drawLine(Offset(w * 0.84, h * 0.72), Offset(w * 0.78, h * 0.65), bikePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Task 2 of 3: Memory Recall Screen ────────────────────────────────────────

class MemoryRecallScreen extends StatelessWidget {
  final String language;
  final VoidCallback onContinue;
  final VoidCallback onBack;
  final VoidCallback onClose;

  const MemoryRecallScreen({
    super.key,
    required this.language,
    required this.onContinue,
    required this.onBack,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    const wordList = 'Cow · River · Book · House · Flower';
    const subText = 'We will read some words. Try to remember them.';

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            StepProgressHeader(currentStep: 2, onBack: onBack, onClose: onClose),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Large Cyan Audio Icon Box
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.volume_up_rounded,
                          size: 38,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Listen carefully',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subText,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSans(fontSize: 13, color: AppColors.muted),
                    ),
                    const SizedBox(height: 32),

                    // Words Display Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        wordList,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: () => TtsService().speak(
                        'Cow, River, Book, House, Flower. Try to remember these words.',
                        language,
                      ),
                      icon: const Icon(Icons.replay, size: 16, color: AppColors.primaryDark),
                      label: const Text('Listen Again', style: TextStyle(color: AppColors.primaryDark, fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryLight,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Continue Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'I heard the words — continue',
                    style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Task 3 of 3: Conversational Prompt Screen ────────────────────────────────

class ConversationalTaskScreen extends StatelessWidget {
  final String language;
  final VoidCallback onStartSpeaking;
  final VoidCallback onBack;
  final VoidCallback onClose;

  const ConversationalTaskScreen({
    super.key,
    required this.language,
    required this.onStartSpeaking,
    required this.onBack,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    const prompt = 'Tell us about something you enjoy doing.';

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            StepProgressHeader(currentStep: 3, onBack: onBack, onClose: onClose),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Chat message icon box
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 36,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'One more',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      prompt,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSans(fontSize: 14, color: AppColors.textSub),
                    ),
                    const SizedBox(height: 24),

                    // Quote Card: "There are no right or wrong answers."
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        '“There are no right or wrong answers.”',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSans(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Listen button
                    InkWell(
                      onTap: () => TtsService().speak(prompt, language),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.volume_up, size: 16, color: AppColors.primaryDark),
                            const SizedBox(width: 6),
                            Text(
                              'Listen',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Start Speaking Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onStartSpeaking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'Start Speaking',
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Recording Screen with Live Oscillating Waveforms ─────────────────────────

class RecordingScreen extends StatefulWidget {
  final AudioRecorderService recorder;
  final int stepIndex; // 1, 2, 3
  final VoidCallback onFinish;

  const RecordingScreen({
    super.key,
    required this.recorder,
    required this.stepIndex,
    required this.onFinish,
  });

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> with SingleTickerProviderStateMixin {
  int _seconds = 0;
  Timer? _timer;
  late AnimationController _waveAnim;

  @override
  void initState() {
    super.initState();
    _waveAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
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
    _waveAnim.dispose();
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
        title: Text(
          'Task ${widget.stepIndex} of 3 Recording',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.text),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Pulsating Mic Button
            GestureDetector(
              onTap: () {
                if (widget.recorder.isPaused) {
                  widget.recorder.resume();
                  _waveAnim.repeat();
                } else {
                  widget.recorder.pause();
                  _waveAnim.stop();
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
                      color: AppColors.danger.withValues(alpha: 0.35),
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

            // Live Animated Sound Waves
            AnimatedBuilder(
              animation: _waveAnim,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(24, (index) {
                    final phase = index * (pi / 6.0);
                    final sinVal = widget.recorder.isPaused
                        ? 0.0
                        : sin(_waveAnim.value * 2 * pi + phase).abs();
                    final height = 6.0 + (sinVal * 34.0);

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 4,
                      height: height,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.6 + (sinVal * 0.4)),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                );
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
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

// ─── Processing Animation Screen ──────────────────────────────────────────────

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

// ─── Screening Result Screen ──────────────────────────────────────────────────

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
