import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Centralized color definitions for the app
///
/// Usage: AppColors.primaryGreen
///
/// Benefits:
/// - Single source of truth for colors
/// - Easy to change colors globally
/// - Consistent color usage across the app
/// - Better maintainability
/// - Theme-aware (light/dark/system)
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Get current theme colors
  static AppColorPalette get _colors {
    try {
      return AppTheme.lightColors;
    } catch (e) {
      // Fallback to light theme if theme controller is not initialized
      debugPrint(
        'Theme controller not initialized, using light theme fallback: $e',
      );
      return AppTheme.lightColors;
    }
  }

  // Primary Colors
  static Color get primaryGreen => _colors.primaryGreen;
  static Color get primaryBlue => _colors.primaryBlue;
  static Color get primaryRed => _colors.primaryRed;
  static Color get primaryIndigo => _colors.primaryIndigo;
  static Color get primaryLightGreen => _colors.primaryLightGreen;
  static Color get primaryLightGreenAlt => _colors.primaryLightGreenAlt;

  // Background Colors
  static Color get backgroundLight => _colors.backgroundLight;
  static Color get backgroundWhite => _colors.backgroundWhite;
  static Color get backgroundGrey => _colors.backgroundGrey;
  static Color get backgroundCard => _colors.backgroundCard;

  // Text Colors
  static Color get textPrimary => _colors.textPrimary;
  static Color get textSecondary => _colors.textSecondary;
  static Color get textLight => _colors.textLight;
  static Color get textDark => _colors.textDark;
  static Color get textGrey => _colors.textGrey;
  static Color get textWhite => _colors.textWhite;

  // Status Colors
  static Color get success => _colors.success;
  static Color get warning => _colors.warning;
  static Color get error => _colors.error;
  static Color get info => _colors.info;

  // Border Colors
  static Color get borderLight => _colors.borderLight;
  static Color get borderMedium => _colors.borderMedium;

  // Shadow Colors
  static Color get shadowLight => _colors.shadowLight;
  static Color get shadowMedium => _colors.shadowMedium;

  // Overlay Colors
  static Color get overlayLight => _colors.overlayLight;
  static Color get overlayMedium => _colors.overlayMedium;
  static Color get overlayIndigo => _colors.overlayIndigo;

  // Transparent Colors
  static Color get transparent => _colors.transparent;

  // Material Colors (for backward compatibility)
  static Color get materialGreen => _colors.materialGreen;
  static Color get materialOrange => _colors.materialOrange;
  static Color get materialGrey => _colors.materialGrey;
  static Color get materialPurple => _colors.materialPurple;
  static Color get materialBlue => _colors.materialBlue;
  static Color get materialRed => _colors.materialRed;
  static Color get materialWhite => _colors.materialWhite;
}
