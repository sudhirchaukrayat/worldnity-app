import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/lesson.dart';

/// Cyber Safety Lessons — PRD V1 Feature 6
class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  final Set<int> _completed = {};
  int? _expandedIndex;

  IconData _iconFor(String key) {
    switch (key) {
      case 'otp':
        return Icons.sms_outlined;
      case 'link':
        return Icons.link_outlined;
      case 'loan':
        return Icons.request_quote_outlined;
      case 'upi':
        return Icons.qr_code_2;
      case 'password':
        return Icons.lock_outline;
      case 'social':
        return Icons.person_outline;
      case 'call':
        return Icons.call_outlined;
      case 'qr':
        return Icons.qr_code;
      default:
        return Icons.school_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _completed.length / lessons.length;

    return Scaffold(
      appBar: AppBar(title: Text('Cyber Safety Lessons', style: AppTextStyles.h3)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.bgMuted),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Aapki Progress', style: AppTextStyles.cardTitle),
                      Text('${_completed.length}/${lessons.length}', style: AppTextStyles.cardTitle.copyWith(color: AppColors.brand)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: AppColors.bgMuted,
                      color: AppColors.brand,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...List.generate(lessons.length, (i) {
              final lesson = lessons[i];
              final isDone = _completed.contains(i);
              final isExpanded = _expandedIndex == i;

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.brand.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(_iconFor(lesson.iconKey), color: AppColors.brand),
                      ),
                      title: Text(lesson.title, style: AppTextStyles.cardTitle),
                      trailing: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: AppColors.textFaint,
                      ),
                      onTap: () => setState(() => _expandedIndex = isExpanded ? null : i),
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(lesson.content, style: AppTextStyles.bodyMuted),
                            const SizedBox(height: 14),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => setState(() {
                                  if (isDone) {
                                    _completed.remove(i);
                                  } else {
                                    _completed.add(i);
                                  }
                                }),
                                icon: Icon(
                                  isDone ? Icons.check_circle : Icons.check_circle_outline,
                                  size: 18,
                                  color: isDone ? AppColors.success : AppColors.textFaint,
                                ),
                                label: Text(
                                  isDone ? 'Complete Kiya' : 'Complete Mark Karein',
                                  style: AppTextStyles.cardTitle.copyWith(
                                    color: isDone ? AppColors.success : AppColors.textPrimary,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: isDone ? AppColors.success : AppColors.bgMuted,
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
