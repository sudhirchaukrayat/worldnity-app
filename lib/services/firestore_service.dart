import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/scam.dart';

/// Fetches Scam Feed data directly from Firestore via REST API.
/// No Firebase SDK / login / google-services.json needed — works as long as
/// Firestore rules allow read access (true while in "test mode").
class FirestoreService {
  // Your Firebase project ID (visible in Firebase Console URL / project selector)
  static const String projectId = 'worldnity-cyberguard';

  static const String _baseUrl =
      'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

  static Future<List<Scam>> fetchScams() async {
    final response = await http.get(Uri.parse('$_baseUrl/scams'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load scams (status ${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final documents = (data['documents'] as List?) ?? [];

    return documents.map((doc) {
      final fields = doc['fields'] as Map<String, dynamic>;
      return Scam(
        title: _str(fields, 'title'),
        description: _str(fields, 'description'),
        riskLevel: _str(fields, 'riskLevel'),
        category: _str(fields, 'category'),
        imageUrl: _str(fields, 'imageUrl'),
        preventionTips: _list(fields, 'preventionTips'),
      );
    }).toList();
  }

  static String _str(Map<String, dynamic> fields, String key) {
    return fields[key]?['stringValue'] as String? ?? '';
  }

  static List<String> _list(Map<String, dynamic> fields, String key) {
    final arr = fields[key]?['arrayValue']?['values'] as List?;
    if (arr == null) return [];
    return arr.map((v) => v['stringValue'] as String? ?? '').toList();
  }

  /// Submit a community scam report (PRD Chapter 8.9 — V1 simplified version).
  /// Report goes to "reports" collection with status "pending" for moderator review.
  static Future<void> submitReport({
    required String category,
    required String description,
    required String date,
    String? state,
    String? city,
    String? evidence,
  }) async {
    final fields = {
      'category': {'stringValue': category},
      'description': {'stringValue': description},
      'date': {'stringValue': date},
      'state': {'stringValue': state ?? ''},
      'city': {'stringValue': city ?? ''},
      'evidence': {'stringValue': evidence ?? ''},
      'status': {'stringValue': 'pending'},
      'submittedAt': {'timestampValue': DateTime.now().toUtc().toIso8601String()},
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/reports'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'fields': fields}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit report (status ${response.statusCode})');
    }
  }
}
