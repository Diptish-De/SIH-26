import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/screening_models.dart';
import '../services/tts_service.dart';
import '../widgets/apk_download_dialog.dart';

// ─── Language Screen ──────────────────────────────────────────────────────────

class LanguageSelectScreen extends StatelessWidget {
  final String selectedLang;
  final Function(String code) onSelect;
  final VoidCallback onContinue;

  const LanguageSelectScreen({
    super.key,
    required this.selectedLang,
    required this.onSelect,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('SwarSanket', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.primary)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose your language', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.text)),
            const SizedBox(height: 4),
            Text('भाषा चुनें (You can change this later)', style: GoogleFonts.notoSans(fontSize: 13, color: AppColors.muted)),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.6,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: kAppLanguages.length,
                itemBuilder: (context, index) {
                  final lang = kAppLanguages[index];
                  final isSelected = lang.code == selectedLang;
                  return InkWell(
                    onTap: () => onSelect(lang.code),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryLight : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(lang.native, style: GoogleFonts.notoSans(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text)),
                          Text(lang.name, style: GoogleFonts.notoSans(fontSize: 12, color: AppColors.muted)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onContinue,
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Welcome Screen ───────────────────────────────────────────────────────────

class WelcomeScreen extends StatelessWidget {
  final String language;
  final VoidCallback onStart;

  const WelcomeScreen({super.key, required this.language, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFB2EBF2), Color(0xFFE0F7FA)]),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Center(
                  child: Icon(Icons.mic_rounded, size: 64, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 24),
              Text('Hello (नमस्ते) 👋', style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.text)),
              const SizedBox(height: 8),
              Text(
                'Let\'s do a short Voice Check. This takes about 3–5 minutes.',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSans(fontSize: 15, color: AppColors.textSub),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => TtsService().speak('Let\'s do a short Voice Check.', language),
                icon: const Icon(Icons.volume_up, size: 18, color: AppColors.primaryDark),
                label: const Text('Listen', style: TextStyle(color: AppColors.primaryDark)),
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
                  child: const Text('Start Voice Check'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Home Screen ──────────────────────────────────────────────────────────────

class HomeScreen extends StatelessWidget {
  final String userName;
  final String language;
  final VoidCallback onStartCheck;
  final VoidCallback onDoctorDash;
  final VoidCallback onHistory;
  final VoidCallback onCaregiver;
  final VoidCallback onHealthWorker;
  final VoidCallback onHelp;
  final VoidCallback onSettings;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.language,
    required this.onStartCheck,
    required this.onDoctorDash,
    required this.onHistory,
    required this.onCaregiver,
    required this.onHealthWorker,
    required this.onHelp,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.waves, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Text('SwarSanket', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.text)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: AppColors.primary),
            onPressed: () => showDialog(context: context, builder: (_) => const ApkDownloadDialog()),
          ),
          IconButton(
            icon: const Icon(Icons.medical_services_outlined, color: AppColors.primary),
            onPressed: onDoctorDash,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello, $userName 👋', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.text)),
            Text('How are you feeling today?', style: GoogleFonts.notoSans(fontSize: 13, color: AppColors.muted)),
            const SizedBox(height: 16),

            // Hero Voice Check Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF0E7490), Color(0xFF155E75)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(16)),
                        child: const Icon(Icons.mic, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ready when you are', style: GoogleFonts.notoSans(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600)),
                          Text('Voice Check', style: GoogleFonts.outfit(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Take a short 3–5 minute screening. Speak naturally — there are no right or wrong answers.',
                    style: GoogleFonts.notoSans(color: Colors.white.withOpacity(0.85), fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onStartCheck,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primaryDark,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('START VOICE CHECK'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Latest Check Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PREVIOUS CHECK', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.muted)),
                      const SizedBox(height: 2),
                      Text('Voice Screening #2026-08', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.text)),
                      Text('28 Aug 2026 · Hindi', style: GoogleFonts.notoSans(fontSize: 11, color: AppColors.muted)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.warningBg, borderRadius: BorderRadius.circular(12)),
                    child: const Text('Follow-up', style: TextStyle(color: AppColors.warning, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Actions Grid
            Row(
              children: [
                _buildQuickAction('History', Icons.history, onHistory),
                const SizedBox(width: 10),
                _buildQuickAction('Caregiver', Icons.people_outline, onCaregiver),
                const SizedBox(width: 10),
                _buildQuickAction('Health Worker', Icons.health_and_safety_outlined, onHealthWorker),
              ],
            ),
            const SizedBox(height: 16),

            // APK Download Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF0F172A)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.android, color: Colors.cyanAccent, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SwarSanket Android APK', style: GoogleFonts.outfit(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        Text('Direct download for phones', style: GoogleFonts.notoSans(color: Colors.white60, fontSize: 11)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => showDialog(context: context, builder: (_) => const ApkDownloadDialog()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    child: const Text('Get APK', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(String title, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(height: 6),
              Text(title, style: GoogleFonts.notoSans(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.text)),
            ],
          ),
        ),
      ),
    );
  }
}
