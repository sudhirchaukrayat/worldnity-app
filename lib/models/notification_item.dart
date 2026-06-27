/// Notifications & Alerts — PRD Chapter 19.5
/// V1: in-app notification feed (push notifications via FCM deferred to later,
/// since that needs extra native setup we've avoided so far).
class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String category; // Scam Alert, Local Alert, Learning Reminder, Family, Community, Consultation, System
  final DateTime createdAt;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.createdAt,
  });
}
