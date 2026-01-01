import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/counter_item.dart';

class LocalStorage {
  static const _keyCounters = 'counters';
  static const _keyViewMode = 'viewMode';
  static const _keyTheme = 'themeMode';

  static Future<List<CounterItem>> loadCounters() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyCounters) ?? [];
    return list.map((e) => CounterItem.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> saveCounters(List<CounterItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final list = items.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_keyCounters, list);
  }

  static Future<String> loadViewMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyViewMode) ?? 'list';
  }

  static Future<void> saveViewMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyViewMode, mode);
  }

  static Future<String?> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyTheme);
  }

  static Future<void> saveTheme(String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTheme, themeName);
  }
}