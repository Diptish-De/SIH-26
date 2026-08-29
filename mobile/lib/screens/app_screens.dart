import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/apk_download_dialog.dart';

// ─── Smartphone Shell Wrapper (Figma Simulation on Desktop/Web) ───────────────

class FigmaPhoneFrame extends StatelessWidget {
  final Widget child;
  final String currentScreen;
  final bool isOnline;
  final VoidCallback onToggleOnline;
  final VoidCallback onDoctorView;
  final VoidCallback onReminder;
  final VoidCallback onErrorState;
  final VoidCallback onEmptyState;
  final VoidCallback onRestart;

  const FigmaPhoneFrame({
    super.key,
    required this.child,
    required this.currentScreen,
    required this.isOnline,
    required this.onToggleOnline,
    required this.onDoctorView,
    required this.onReminder,
    required this.onErrorState,
    required this.onEmptyState,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    if (!isDesktop) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(child: child),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.desktopBg,
      body: Stack(
        children: [
          // Top-right Control Pills (Identical to Figma)
          Positioned(
            top: 24,
            right: 24,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: [
                _buildPill(
                  isOnline ? 'Online' : 'Offline',
                  isOnline ? const Color(0xFF0284C7) : const Color(0xFF64748B),
                  onToggleOnline,
                  icon: isOnline ? Icons.wifi : Icons.wifi_off,
                ),
                _buildPill('Doctor View', const Color(0xFF1E293B), onDoctorView, icon: Icons.medical_services_outlined),
                _buildPill('Reminder', const Color(0xFF7C3AED), onReminder, icon: Icons.notifications_none),
                _buildPill('Error State', const Color(0xFFDC2626), onErrorState),
                _buildPill('Empty State', const Color(0xFF1E293B), onEmptyState),
                _buildPill('Restart', const Color(0xFF1E293B), onRestart, icon: Icons.restart_alt),
              ],
            ),
          ),

          // Centered Smartphone Container
          Center(
            child: Container(
              width: 390,
              height: 800,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(44),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 40,
                    spreadRadius: 10,
                    offset: const Offset(0, 16),
                  ),
                ],
                border: Border.all(color: const Color(0xFF334155), width: 3),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(41),
                child: Column(
                  children: [
                    // Dynamic Island Status Bar
                    Container(
                      color: AppColors.bg,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '9:41',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppColors.text,
                            ),
                          ),
                          // Dynamic Island Pill
                          Container(
                            width: 80,
                            height: 18,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          const Row(
                            children: [
                              Icon(Icons.signal_cellular_alt, size: 14, color: AppColors.text),
                              SizedBox(width: 4),
                              Icon(Icons.wifi, size: 14, color: AppColors.text),
                              SizedBox(width: 4),
                              Icon(Icons.battery_full, size: 14, color: AppColors.text),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Active Screen Content
                    Expanded(child: child),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPill(String label, Color color, VoidCallback onTap, {IconData? icon}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 14),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.notoSans(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Exact Figma Home Screen ──────────────────────────────────────────────────

class HomeScreen extends StatelessWidget {
  final String userName;
  final String language;
  final bool hasPreviousCheck;
  final bool hasError;
  final VoidCallback onStartCheck;
  final VoidCallback onHistory;
  final VoidCallback onHelp;
  final VoidCallback onCaregiver;
  final VoidCallback onProfile;
  final VoidCallback onSettings;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.language,
    this.hasPreviousCheck = true,
    this.hasError = false,
    required this.onStartCheck,
    required this.onHistory,
    required this.onHelp,
    required this.onCaregiver,
    required this.onProfile,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header Row: Hello, Friend 👋 + Sound Wave Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Hello, $userName',
                                style: GoogleFonts.outfit(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text('👋', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'How are you feeling today?',
                            style: GoogleFonts.notoSans(
                              fontSize: 13,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                      // Sound wave button
                      InkWell(
                        onTap: onSettings,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.waves, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Optional Error Banner
                  if (hasError)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.danger, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Unable to connect to server. Results saved locally.',
                              style: GoogleFonts.notoSans(fontSize: 12, color: Colors.red.shade900),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Hero Voice Check Card (Teal rounded card with START button)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0891B2), Color(0xFF0E7490)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Mic + Title
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.mic, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ready when you are',
                                  style: GoogleFonts.notoSans(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.85),
                                  ),
                                ),
                                Text(
                                  'Voice Check',
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Take a short 3–5 minute screening. Speak naturally — there are no right or wrong answers.',
                          style: GoogleFonts.notoSans(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: onStartCheck,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primaryDark,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'START',
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // PREVIOUS CHECK Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PREVIOUS CHECK',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.muted,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hasPreviousCheck ? 'Last check' : 'No previous checks',
                                  style: GoogleFonts.outfit(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.text,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  hasPreviousCheck ? '12 Aug 2026' : 'Start your first screening',
                                  style: GoogleFonts.notoSans(
                                    fontSize: 12,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                            if (hasPreviousCheck)
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.success,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Completed',
                                    style: GoogleFonts.notoSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.success,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 3 Quick Action Tiles: History, Help, Caregiver
                  Row(
                    children: [
                      _buildQuickAction('History', Icons.history, onHistory),
                      const SizedBox(width: 10),
                      _buildQuickAction('Help', Icons.help_outline, onHelp),
                      const SizedBox(width: 10),
                      _buildQuickAction('Caregiver', Icons.people_outline, onCaregiver),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // In-App APK Download & QR Button
                  InkWell(
                    onTap: () => showDialog(context: context, builder: (_) => const ApkDownloadDialog()),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.android, color: Colors.cyanAccent, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Download Android APK (QR Scan)',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.white60, size: 12),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Navigation Bar (Home, History, Help, Profile)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(Icons.home, 'Home', isSelected: true, onTap: () {}),
                _buildNavItem(Icons.history, 'History', isSelected: false, onTap: onHistory),
                _buildNavItem(Icons.help_outline, 'Help', isSelected: false, onTap: onHelp),
                _buildNavItem(Icons.person_outline, 'Profile', isSelected: false, onTap: onProfile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String title, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 26),
              const SizedBox(height: 6),
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : AppColors.muted,
            size: 22,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.notoSans(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.primary : AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
