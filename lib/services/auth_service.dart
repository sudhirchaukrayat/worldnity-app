import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Authentication via Firebase Identity Toolkit REST API.
/// No firebase_auth SDK / native setup needed — consistent with our
/// REST-only approach used for Firestore.
class AuthService {
  // Web API Key from Firebase Console > Project settings > General
  static const String _apiKey = 'AIzaSyCu0GfF-Skr0vP-QVOL21EmlesyUw1_SnU';

  static const String _signUpUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_apiKey';
  static const String _signInUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_apiKey';

  static const _kUid = 'auth_uid';
  static const _kEmail = 'auth_email';
  static const _kIdToken = 'auth_id_token';

  /// Sign up a new user with email + password.
  /// Throws a friendly error message string on failure.
  static Future<void> signUp(String email, String password) async {
    final response = await http.post(
      Uri.parse(_signUpUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    await _handleAuthResponse(response);
  }

  /// Sign in an existing user with email + password.
  static Future<void> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse(_signInUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    await _handleAuthResponse(response);
  }

  static Future<void> _handleAuthResponse(http.Response response) async {
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      final errorMessage = data['error']?['message'] as String? ?? 'UNKNOWN_ERROR';
      throw _friendlyError(errorMessage);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUid, data['localId'] as String);
    await prefs.setString(_kEmail, data['email'] as String);
    await prefs.setString(_kIdToken, data['idToken'] as String);
  }

  static String _friendlyError(String code) {
    if (code.contains('EMAIL_EXISTS')) {
      return 'Ye email already registered hai. Login karein.';
    }
    if (code.contains('EMAIL_NOT_FOUND')) {
      return 'Ye email registered nahi hai. Sign Up karein.';
    }
    if (code.contains('INVALID_PASSWORD') || code.contains('INVALID_LOGIN_CREDENTIALS')) {
      return 'Email ya password galat hai.';
    }
    if (code.contains('WEAK_PASSWORD')) {
      return 'Password kam se kam 6 characters ka hona chahiye.';
    }
    if (code.contains('INVALID_EMAIL')) {
      return 'Valid email address daalein.';
    }
    if (code.contains('TOO_MANY_ATTEMPTS')) {
      return 'Bahut zyada attempts ho gaye. Thodi der baad try karein.';
    }
    return 'Kuch gadbad ho gayi. Phir try karein.';
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kUid) != null;
  }

  static Future<String?> currentEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kEmail);
  }

  static Future<String?> currentUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kUid);
  }

  static Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUid);
    await prefs.remove(_kEmail);
    await prefs.remove(_kIdToken);
  }
}
