import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static SharedPrefsService? _instance;
  static SharedPreferences? _prefs;

  static const String _keyEmail = 'email';
  static const String _keyPassword = 'password';

  SharedPrefsService._();

  static Future<SharedPrefsService> getInstance() async {
    _instance ??= SharedPrefsService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  Future<bool> saveEmail(String email) async {
    return await _prefs!.setString(_keyEmail, email);
  }

  String? getEmail() {
    return _prefs!.getString(_keyEmail);
  }

  Future<bool> removeEmail() async {
    return await _prefs!.remove(_keyEmail);
  }

  Future<bool> savePassword(String password) async {
    return await _prefs!.setString(_keyPassword, password);
  }

  String? getPassword() {
    return _prefs!.getString(_keyPassword);
  }

  Future<bool> removePassword() async {
    return await _prefs!.remove(_keyPassword);
  }

  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    await saveEmail(email);
    await savePassword(password);
  }

  Map<String, String?> getCredentials() {
    return {
      'email': getEmail(),
      'password': getPassword(),
    };
  }

  Future<void> clearAll() async {
    await _prefs!.clear();
  }
}