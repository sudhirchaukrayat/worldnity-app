import 'package:shared_preferences/shared_preferences.dart';

/// Stores basic profile + family membership info locally on device.
/// V1 simplified approach — no full login/password system yet.
class LocalProfileService {
  static const _kName = 'profile_name';
  static const _kType = 'profile_type';
  static const _kFamilyCode = 'family_code';
  static const _kFamilyRole = 'family_role';
  static const _kCompletedLessons = 'completed_lessons';

  static Future<void> saveProfile({required String name, required String userType}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kName, name);
    await prefs.setString(_kType, userType);
  }

  static Future<Map<String, String>?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_kName);
    final type = prefs.getString(_kType);
    if (name == null || type == null) return null;
    return {'name': name, 'userType': type};
  }

  static Future<void> saveFamily({required String code, required String role}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kFamilyCode, code);
    await prefs.setString(_kFamilyRole, role);
  }

  static Future<Map<String, String>?> getFamily() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_kFamilyCode);
    if (code == null) return null;
    final role = prefs.getString(_kFamilyRole);
    return {'code': code, 'role': role ?? 'Family Member'};
  }

  static Future<void> setCompletedLessons(Set<int> indices) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kCompletedLessons, indices.map((i) => i.toString()).toList());
  }

  static Future<Set<int>> getCompletedLessons() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kCompletedLessons) ?? [];
    return list.map((s) => int.parse(s)).toSet();
  }
}
