import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/screening_models.dart';

class DoctorDashboardScreen extends StatelessWidget {
  final VoidCallback onBack;
  final Function(String name) onSelectPatient;

  const DoctorDashboardScreen({
    super.key,
    required this.onBack,
    required this.onSelectPatient,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark clinical mode
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: onBack,
        ),
        title: Text(
          'Doctor Clinical Dashboard',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                _buildStatCard('Patients', '4', Colors.white),
                const SizedBox(width: 8),
                _buildStatCard('Elevated', '2', Colors.amber),
                const SizedBox(width: 8),
                _buildStatCard('ML Accuracy', '93%', Colors.cyanAccent),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Patient Screenings',
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.text),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildPatientTile(context, 'Rama Devi', 72, 'Hindi', '28 Aug 2026', ScreeningRisk.elevated),
                        _buildPatientTile(context, 'Suresh Kumar', 68, 'Hindi', '15 Aug 2026', ScreeningRisk.low),
                        _buildPatientTile(context, 'Meera Bai', 80, 'Bengali', '12 Aug 2026', ScreeningRisk.elevated),
                        _buildPatientTile(context, 'Lakshmi Devi', 75, 'Hindi', '09 Aug 2026', ScreeningRisk.low),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Text(value, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label, style: GoogleFonts.notoSans(fontSize: 11, color: Colors.white60)),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientTile(
    BuildContext context,
    String name,
    int age,
    String lang,
    String date,
    ScreeningRisk risk,
  ) {
    final isElevated = risk == ScreeningRisk.elevated;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: () => onSelectPatient(name),
        title: Text('$name, $age', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.text)),
        subtitle: Text('$lang · $date', style: GoogleFonts.notoSans(fontSize: 12, color: AppColors.muted)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isElevated ? AppColors.warningBg : AppColors.successBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            isElevated ? 'ELEVATED' : 'NORMAL',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isElevated ? AppColors.warning : AppColors.success,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Doctor Patient Longitudinal View ─────────────────────────────────────────

class DoctorPatientDetailScreen extends StatelessWidget {
  final String patientName;
  final VoidCallback onBack;

  const DoctorPatientDetailScreen({
    super.key,
    required this.patientName,
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
        title: Text('$patientName (72)', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.text)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warningBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 28),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Elevated Cognitive Risk (88%)', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.warning)),
                      Text('Acoustic pauses & vocal jitter detected', style: GoogleFonts.notoSans(fontSize: 12, color: AppColors.textSub)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // fl_chart Longitudinal Trend
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Longitudinal Risk Trend (%)', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.muted)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 140,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (val, meta) {
                                switch (val.toInt()) {
                                  case 0: return const Text('Jun', style: TextStyle(fontSize: 11));
                                  case 1: return const Text('Jul', style: TextStyle(fontSize: 11));
                                  case 2: return const Text('Aug', style: TextStyle(fontSize: 11));
                                  case 3: return const Text('Sep', style: TextStyle(fontSize: 11));
                                  default: return const Text('');
                                }
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [
                              FlSpot(0, 22),
                              FlSpot(1, 25),
                              FlSpot(2, 38),
                              FlSpot(3, 88),
                            ],
                            isCurved: true,
                            color: AppColors.primary,
                            barWidth: 3,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(show: true, color: AppColors.primaryLight.withValues(alpha: 0.5)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Biomarkers summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Acoustic Biomarkers', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.muted)),
                  const SizedBox(height: 12),
                  _buildBiomarkerRow('Speech Rate', '68 WPM', 'Below average (70-110 WPM)'),
                  _buildBiomarkerRow('Pause Pattern Ratio', '45%', 'High latency intervals'),
                  _buildBiomarkerRow('Pitch Jitter', '3.2%', 'Elevated vocal micro-instability'),
                  _buildBiomarkerRow('Harmonics-to-Noise', '21.0 dB', 'Acceptable resonance'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Share / Export Report Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Clinical Screening Report exported successfully.'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
                icon: const Icon(Icons.picture_as_pdf, color: Colors.white, size: 20),
                label: Text(
                  'Export Clinical Report (PDF)',
                  style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildBiomarkerRow(String label, String value, String sub) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.notoSans(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.text)),
              Text(sub, style: GoogleFonts.notoSans(fontSize: 11, color: AppColors.muted)),
            ],
          ),
          Text(value, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
        ],
      ),
    );
  }
}
