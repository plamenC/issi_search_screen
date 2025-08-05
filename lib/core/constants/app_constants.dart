// App-wide constants
class AppConstants {
  // API and Network
  static const int apiTimeoutSeconds = 30;
  static const int maxRetries = 3;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache
  static const int cacheExpiryMinutes = 5;
  static const int maxCacheSize = 1000;

  // UI
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 8.0;
  static const double cardElevation = 2.0;

  // Animation
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Search
  static const int searchDebounceMs = 300;
  static const int minSearchLength = 2;

  // Error messages
  static const String networkErrorMessage = 'Проверете интернет връзката';
  static const String serverErrorMessage = 'Грешка в сървъра';
  static const String unknownErrorMessage = 'Неизвестна грешка';
  static const String timeoutErrorMessage = 'Времето за изчакване изтече';
}
