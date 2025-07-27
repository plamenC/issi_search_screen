import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark, system }

class ThemeNotifier extends StateNotifier<AppThemeMode> {
  static const String _themeKey = 'app_theme_mode';

  ThemeNotifier() : super(AppThemeMode.system) {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 2; // Default to system
      state = AppThemeMode.values[themeIndex];
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
      state = AppThemeMode.system;
    }
  }

  Future<void> _saveThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, state.index);
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }

  void changeTheme(AppThemeMode mode) {
    state = mode;
    _saveThemePreference();
  }

  void toggleTheme() {
    final newMode = state == AppThemeMode.light
        ? AppThemeMode.dark
        : AppThemeMode.light;
    changeTheme(newMode);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  return ThemeNotifier();
});
