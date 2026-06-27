import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/notification_item.dart';
import '../services/firestore_service.dart';
import '../services/local_profile_service.dart';

/// Notifications & Alerts — PRD Chapter 19.5
/// V1: in-app feed. Admin adds entries via Firebase Console "notifications" collection.
class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  late Future<List<NotificationItem>> _notificationsFuture;
  Set<String> _readIds = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _notificationsFuture = FirestoreService.fetchNotifications();
    LocalProfileService.getReadNotificationIds().then((ids) {
      setState(() => _readIds = ids);
    });
  }

  Future<void> _refresh() async {
    setState(_load);
    await _notificationsFuture;
  }

  IconData _iconFor(String category) {
    switch (category) {
      case 'Scam Alert':
        return Icons.warning_amber_rounded;
      case 'Local Alert':
        return Icons.location_on_outlined;
      case 'Learning Reminder':
        return Icons.school_outlined;
      case 'Family':
        return Icons.family_restroom;
      case 'Community':
        return Icons.groups_outlined;
      case 'Consultation':
        return Icons.call_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _colorFor(String category) {
    switch (category) {
      case 'Scam Alert':
        return AppColors.error;
      case 'Local Alert':
        return AppColors.warning;
      default:
        return AppColors.brand;
    }
  }

  String _relativeTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Abhi';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min pehle';
    if (diff.inHours < 24) return '${diff.inHours} ghante pehle';
    if (diff.inDays < 7) return '${diff.inDays} din pehle';
    return '${time.day}/${time.month}/${time.year}';
  }

  void _openNotification(NotificationItem item) {
    if (!_readIds.contains(item.id)) {
      LocalProfileService.markNotificationRead(item.id);
      setState(() => _readIds.add(item.id));
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(item.title, style: AppTextStyles.h4),
        content: Text(item.body, style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Theek Hai', style: AppTextStyles.cardTitle.copyWith(color: AppColors.brand)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Alerts', style: AppTextStyles.h3)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: FutureBuilder<List<NotificationItem>>(
            future: _notificationsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 80),
                      child: Center(
                        child: Text('Kuch gadbad ho gayi.\nNeeche kheech ke phir try karo.',
                            textAlign: TextAlign.center, style: AppTextStyles.bodyMuted),
                      ),
                    ),
                  ],
                );
              }
              final items = snapshot.data ?? [];
              if (items.isEmpty) {
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
                      child: Center(
                        child: Text(
                          'Abhi koi alert nahi hai.\nNayi scam alerts aur reminders yahan dikhenge.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMuted,
                        ),
                      ),
                    ),
                  ],
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isUnread = !_readIds.contains(item.id);
                  final color = _colorFor(item.category);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    color: isUnread ? color.withOpacity(0.05) : Colors.white,
                    child: ListTile(
                      onTap: () => _openNotification(item),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(_iconFor(item.category), color: color),
                      ),
                      title: Text(
                        item.title,
                        style: isUnread
                            ? AppTextStyles.cardTitle
                            : AppTextStyles.cardTitle.copyWith(color: AppColors.textMuted, fontWeight: FontWeight.w500),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(item.body, maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyMuted),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (isUnread)
                            Container(
                              width: 8, height: 8,
                              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                            ),
                          const SizedBox(height: 6),
                          Text(_relativeTime(item.createdAt), style: AppTextStyles.label),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
