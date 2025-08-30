import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/theme_provider.dart';

class AppTheme {
  // Light Theme Colors
  static const LightColors lightColors = LightColors();

  // Dark Theme Colors
  static const DarkColors darkColors = DarkColors();

  // Get current theme colors based on mode
  static AppColorPalette getColors(
    AppThemeMode mode,
    Brightness platformBrightness,
  ) {
    final isDark = _isDarkMode(mode, platformBrightness);
    return isDark ? darkColors : lightColors;
  }

  // Check if current mode should use dark theme
  static bool _isDarkMode(AppThemeMode mode, Brightness platformBrightness) {
    switch (mode) {
      case AppThemeMode.light:
        return false;
      case AppThemeMode.dark:
        return true;
      case AppThemeMode.system:
        return platformBrightness == Brightness.dark;
    }
  }

  // Get Material ThemeData
  static ThemeData getThemeData(
    AppThemeMode mode,
    Brightness platformBrightness,
  ) {
    final colors = getColors(mode, platformBrightness);

    return ThemeData(
      useMaterial3: true,
      brightness: _isDarkMode(mode, platformBrightness)
          ? Brightness.dark
          : Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.primaryIndigo,
        brightness: _isDarkMode(mode, platformBrightness)
            ? Brightness.dark
            : Brightness.light,
        primary: colors.primaryIndigo,
        onPrimary: colors.textWhite,
        secondary: colors.primaryGreen,
        onSecondary: colors.textWhite,
        surface: colors.backgroundLight,
        onSurface: colors.textPrimary,
        error: colors.error,
        onError: colors.textWhite,
      ),
      scaffoldBackgroundColor: colors.backgroundLight,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.backgroundCard,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: colors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.backgroundCard,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primaryGreen,
          foregroundColor: colors.textWhite,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.backgroundWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primaryIndigo, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.error),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: colors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: colors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: colors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: colors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: colors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: colors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(color: colors.textPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: colors.textPrimary, fontSize: 14),
        bodySmall: TextStyle(color: colors.textPrimary, fontSize: 12),
        labelLarge: TextStyle(
          color: colors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: colors.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: colors.textPrimary,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
      iconTheme: IconThemeData(color: colors.textLight, size: 24),
      dividerTheme: DividerThemeData(color: colors.borderLight, thickness: 1),
      chipTheme: ChipThemeData(
        backgroundColor: colors.backgroundCard,
        selectedColor: colors.primaryIndigo,
        labelStyle: TextStyle(color: colors.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.backgroundCard,
        selectedItemColor: colors.primaryIndigo,
        unselectedItemColor: colors.textLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: colors.primaryIndigo,
        unselectedLabelColor: colors.textLight,
        indicatorColor: colors.primaryIndigo,
        dividerColor: colors.borderLight,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primaryGreen,
        foregroundColor: colors.textWhite,
        elevation: 4,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.backgroundCard,
        contentTextStyle: TextStyle(color: colors.textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.backgroundCard,
        titleTextStyle: TextStyle(
          color: colors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(color: colors.textPrimary, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: colors.backgroundCard,
        textColor: colors.textPrimary,
        iconColor: colors.textLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primaryIndigo;
          }
          return colors.textLight;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primaryIndigo.withValues(alpha: 0.5);
          }
          return colors.borderLight;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primaryIndigo;
          }
          return colors.backgroundCard;
        }),
        checkColor: WidgetStateProperty.all(colors.textWhite),
        side: BorderSide(color: colors.borderLight),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primaryIndigo;
          }
          return colors.borderLight;
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: colors.primaryIndigo,
        inactiveTrackColor: colors.borderLight,
        thumbColor: colors.primaryIndigo,
        overlayColor: colors.primaryIndigo.withValues(alpha: 0.2),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primaryIndigo,
        linearTrackColor: colors.borderLight,
        circularTrackColor: colors.borderLight,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colors.backgroundCard,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: colors.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        textStyle: TextStyle(color: colors.textPrimary, fontSize: 12),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colors.backgroundCard,
        textStyle: TextStyle(color: colors.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStateProperty.all(colors.backgroundCard),
          elevation: WidgetStateProperty.all(8),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.backgroundCard,
        indicatorColor: colors.primaryIndigo.withValues(alpha: 0.1),
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(
            color: colors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colors.primaryIndigo);
          }
          return IconThemeData(color: colors.textLight);
        }),
      ),
    );
  }
}

// Riverpod provider for theme data
final themeDataProvider = Provider<ThemeData>((ref) {
  final themeMode = ref.watch(themeProvider);
  final platformBrightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
  return AppTheme.getThemeData(themeMode, platformBrightness);
});

// Light Theme Color Palette
class LightColors implements AppColorPalette {
  const LightColors();

  @override
  Color get primaryGreen => const Color(0xFF4CAF50);

  @override
  Color get primaryBlue => const Color(0xFF2196F3);

  @override
  Color get primaryRed => const Color(0xFFFF357C);

  @override
  Color get primaryIndigo => const Color(0xFF1A237E);

  @override
  Color get primaryLightGreen => const Color(0xFF89B82D);

  @override
  Color get primaryLightGreenAlt => const Color(0xFF89B82A);

  @override
  Color get backgroundLight => const Color(0xFFFBFBFE);

  @override
  Color get backgroundWhite => const Color(0xFFFFFFFF);

  @override
  Color get backgroundGrey => const Color(0xFFF5F5F5);

  @override
  Color get backgroundCard => const Color(0xFFEEEFF6);

  @override
  Color get textPrimary => const Color(0xFF212121);

  @override
  Color get textSecondary => const Color(0xFF757575);

  @override
  Color get textLight => const Color(0xFF9394A0);

  @override
  Color get textDark => const Color(0xFF1B1C28);

  @override
  Color get textGrey => const Color(0xFF9596A1);

  @override
  Color get textWhite => const Color(0xFFFFFFFF);

  @override
  Color get success => const Color(0xFF4CAF50);

  @override
  Color get warning => const Color(0xFFFF9800);

  @override
  Color get error => const Color(0xFFF44336);

  @override
  Color get info => const Color(0xFF2196F3);

  @override
  Color get borderLight => const Color(0xFFE0E0E0);

  @override
  Color get borderMedium => const Color(0xFFBDBDBD);

  @override
  Color get shadowLight => const Color(0x1A000000);

  @override
  Color get shadowMedium => const Color(0x33000000);

  @override
  Color get overlayLight => const Color(0x80000000);

  @override
  Color get overlayMedium => const Color(0xCC000000);

  @override
  Color get overlayIndigo => const Color(0x7314162E);

  @override
  Color get transparent => Colors.transparent;

  @override
  Color get materialGreen => Colors.green;

  @override
  Color get materialOrange => Colors.orange;

  @override
  Color get materialGrey => Colors.grey;

  @override
  Color get materialPurple => Colors.purple;

  @override
  Color get materialBlue => Colors.blue;

  @override
  Color get materialRed => Colors.red;

  @override
  Color get materialWhite => Colors.white;
}

// Dark Theme Color Palette
class DarkColors implements AppColorPalette {
  const DarkColors();

  @override
  Color get primaryGreen => const Color(0xFF66BB6A); // Lighter green for dark theme

  @override
  Color get primaryBlue => const Color(0xFF42A5F5); // Lighter blue for dark theme

  @override
  Color get primaryRed => const Color(0xFFFF4081); // Lighter red for dark theme

  @override
  Color get primaryIndigo => const Color(0xFF3F51B5); // Lighter indigo for dark theme

  @override
  Color get primaryLightGreen => const Color(0xFF9CCC65); // Lighter variant

  @override
  Color get primaryLightGreenAlt => const Color(0xFF9CCC62); // Lighter alternative

  @override
  Color get backgroundLight => const Color(0xFF121212); // Dark background

  @override
  Color get backgroundWhite => const Color(0xFF1E1E1E); // Dark surface

  @override
  Color get backgroundGrey => const Color(0xFF2D2D2D); // Dark grey background

  @override
  Color get backgroundCard => const Color(0xFF2A2A2A); // Dark card background

  @override
  Color get textPrimary => const Color(0xFFE0E0E0); // Light text for dark theme

  @override
  Color get textSecondary => const Color(0xFFB0B0B0); // Medium light text

  @override
  Color get textLight => const Color(0xFF9E9E9E); // Light grey text

  @override
  Color get textDark => const Color(0xFFF5F5F5); // Very light text for dark theme

  @override
  Color get textGrey => const Color(0xFFBDBDBD); // Light grey for dark theme

  @override
  Color get textWhite => const Color(0xFFFFFFFF);

  @override
  Color get success => const Color(0xFF66BB6A); // Lighter success for dark theme

  @override
  Color get warning => const Color(0xFFFFB74D); // Lighter warning for dark theme

  @override
  Color get error => const Color(0xFFEF5350); // Lighter error for dark theme

  @override
  Color get info => const Color(0xFF42A5F5); // Lighter info for dark theme

  @override
  Color get borderLight => const Color(0xFF424242); // Darker border for dark theme

  @override
  Color get borderMedium => const Color(0xFF616161); // Medium dark border

  @override
  Color get shadowLight => const Color(0x33000000); // Darker shadow for dark theme

  @override
  Color get shadowMedium => const Color(0x66000000); // Medium dark shadow

  @override
  Color get overlayLight => const Color(0x80000000);

  @override
  Color get overlayMedium => const Color(0xCC000000);

  @override
  Color get overlayIndigo => const Color(0x7314162E);

  @override
  Color get transparent => Colors.transparent;

  @override
  Color get materialGreen => const Color(0xFF66BB6A); // Lighter material green

  @override
  Color get materialOrange => const Color(0xFFFFB74D); // Lighter material orange

  @override
  Color get materialGrey => const Color(0xFF9E9E9E); // Lighter material grey

  @override
  Color get materialPurple => const Color(0xFFAB47BC); // Lighter material purple

  @override
  Color get materialBlue => const Color(0xFF42A5F5); // Lighter material blue

  @override
  Color get materialRed => const Color(0xFFEF5350); // Lighter material red

  @override
  Color get materialWhite => const Color(0xFF1E1E1E); // Dark surface instead of white
}

// Abstract color palette interface
abstract class AppColorPalette {
  Color get primaryGreen;
  Color get primaryBlue;
  Color get primaryRed;
  Color get primaryIndigo;
  Color get primaryLightGreen;
  Color get primaryLightGreenAlt;
  Color get backgroundLight;
  Color get backgroundWhite;
  Color get backgroundGrey;
  Color get backgroundCard;
  Color get textPrimary;
  Color get textSecondary;
  Color get textLight;
  Color get textDark;
  Color get textGrey;
  Color get textWhite;
  Color get success;
  Color get warning;
  Color get error;
  Color get info;
  Color get borderLight;
  Color get borderMedium;
  Color get shadowLight;
  Color get shadowMedium;
  Color get overlayLight;
  Color get overlayMedium;
  Color get overlayIndigo;
  Color get transparent;
  Color get materialGreen;
  Color get materialOrange;
  Color get materialGrey;
  Color get materialPurple;
  Color get materialBlue;
  Color get materialRed;
  Color get materialWhite;
}
