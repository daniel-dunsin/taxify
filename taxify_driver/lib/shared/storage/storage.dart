import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

final SharedPreferencesAsync localStorage = SharedPreferencesAsync();

class AppStorage {
  static Future<void> saveString({
    required String key,
    required String value,
  }) async {
    await localStorage.setString(key, value);
  }

  static Future<String?> getString({required String key}) async {
    return await localStorage.getString(key);
  }

  static Future<void> saveInt({required String key, required int value}) async {
    await localStorage.setInt(key, value);
  }

  static Future<int?> getInt({required String key}) async {
    return await localStorage.getInt(key);
  }

  static Future<void> saveDouble({
    required String key,
    required double value,
  }) async {
    await localStorage.setDouble(key, value);
  }

  static Future<double?> getDouble({required String key}) async {
    return await localStorage.getDouble(key);
  }

  static Future<void> saveBool({
    required String key,
    required bool value,
  }) async {
    await localStorage.setBool(key, value);
  }

  static Future<bool?> getBool({required String key}) async {
    return await localStorage.getBool(key);
  }

  static Future<void> saveObject({
    required String key,
    required Object value,
  }) async {
    await localStorage.setString(key, jsonEncode(value));
  }

  static Future<T?> getObject<T>({required String key}) async {
    final String? jsonString = await localStorage.getString(key);

    if (jsonString == null) return null;
    return jsonDecode(jsonString);
  }
}
