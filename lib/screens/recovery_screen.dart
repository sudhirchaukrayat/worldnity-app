import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/recovery_guide.dart';

/// Fraud Recovery Center — PRD Chapter 8.2
/// Entry screen: select fraud type → view structured recovery guidance.
class RecoveryScreen extends StatelessWidget {
  const RecoveryScreen({super.key});

  IconData _iconFor(String key) {
    switch (key) {
      case 'upi':
        return Icons.qr_code_2;
      case 'bank':
        return Icons.account_balance;
      case 'otp':
        return Icons.sms_outlined;
      case 'loan':
        return Icons.request_quote_outlined;
      case 'social':
        return Icons.person_outline;
      case 'whatsapp':
        return Icons.chat_outlined;
      case 'qr':
        return Icons.qr_code;
      case 'investment':
        return Icons.trending_up;
      case 'job':
        return Icons.work_outline;
      case 'blackmail':
        return Icons.shield_outlined;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fraud Recovery Center', style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.error),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Apna fraud type select karo, hum step-by-step batayenge ab kya karna hai.',
                      style: AppTextStyles.body,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...recoveryGuides.map(
              (guide) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.brand.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_iconFor(guide.iconKey), color: AppColors.brand),
                  ),
                  title: Text(guide.fraudType, style: AppTextStyles.cardTitle),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.textFaint),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RecoveryDetailScreen(guide: guide)),
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

class RecoveryDetailScreen extends StatelessWidget {
  final RecoveryGuide guide;
  const RecoveryDetailScreen({super.key, required this.guide});

  Widget _section(String title, List<String> items, {IconData icon = Icons.check_circle, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.h4),
          const SizedBox(height: 10),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 18, color: color ?? AppColors.success),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item, style: AppTextStyles.body)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(guide.fraudType, style: AppTextStyles.h3)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Kya Hua?', style: AppTextStyles.h4),
            const SizedBox(height: 8),
            Text(guide.whatHappened, style: AppTextStyles.bodyMuted),
            const SizedBox(height: 24),
            _section('Turant Yeh Karein', guide.immediateActions,
                icon: Icons.bolt, color: AppColors.error),
            _section('Evidence Save Karein', guide.evidenceChecklist,
                icon: Icons.camera_alt_outlined, color: AppColors.info),
            _section('Kahan Report Karein', guide.reportingGuidance,
                icon: Icons.local_police_outlined, color: AppColors.brand),
            _section('Future Mein Bachne Ke Liye', guide.preventionTips,
                icon: Icons.check_circle, color: AppColors.success),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Consultation Booking — coming soon')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: AppColors.brand),
                ),
                child: Text(
                  'Need More Help? Book Expert Consultation',
                  style: AppTextStyles.cardTitle.copyWith(color: AppColors.brand),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
