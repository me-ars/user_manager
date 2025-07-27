import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/logged_user.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  DatabaseService._internal();

  SharedPreferences? _prefs;

  static const String _loggedUserKey = 'loggedUser';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save LoggedUser model
  Future<void> saveLoggedUser({required LoggedUser user}) async {
    String jsonString = jsonEncode(user.toJson());
    await _prefs?.setString(_loggedUserKey, jsonString);
  }

  // Get LoggedUser model
  LoggedUser? getLoggedUser() {
    String? jsonString = _prefs?.getString(_loggedUserKey);
    if (jsonString == null) return null;

    try {
      Map<String, dynamic> json = jsonDecode(jsonString);
      return LoggedUser.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearLoggedUser() async {
    await _prefs?.remove(_loggedUserKey);
  }
}
