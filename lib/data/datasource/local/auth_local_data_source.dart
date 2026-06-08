import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _locationKey = 'user_location';
  static const String _hasLocationKey = 'has_location';

  final SharedPreferences _prefs;

  AuthLocalDataSource(this._prefs);

  /// Save Token
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  /// Get Token
  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  /// Save User ID
  Future<void> saveUserId(String id) async {
    await _prefs.setString(_userIdKey, id);
  }

  /// Get User ID
  String? getUserId() {
    return _prefs.getString(_userIdKey);
  }

  Future<void> saveUserLocation(Map<String, dynamic> locationData) async {
    // Map ko JSON string mein convert kar ke save karain ge
    await _prefs.setString(_locationKey, jsonEncode(locationData));
    await _prefs.setBool(_hasLocationKey, true);
  }

  /// ✨ Get Cached User Location Data Map
  Map<String, dynamic>? getUserLocation() {
    final locationStr = _prefs.getString(_locationKey);
    if (locationStr != null) {
      return jsonDecode(locationStr) as Map<String, dynamic>;
    }
    return null;
  }

  /// ✨ Fast check to see if user has a configured location
  bool hasLocationSaved() {
    return _prefs.getBool(_hasLocationKey) ?? false;
  }

  /// Clear Storage (Logout)
  Future<void> clear() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_locationKey);
    await _prefs.remove(_hasLocationKey);
  }
}
