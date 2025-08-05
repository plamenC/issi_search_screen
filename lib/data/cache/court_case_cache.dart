import 'package:flutter/foundation.dart';
import '../../domain/models/court_case.dart';

class CourtCaseCache {
  static final CourtCaseCache _instance = CourtCaseCache._internal();
  factory CourtCaseCache() => _instance;
  CourtCaseCache._internal();

  final Map<String, CourtCase> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  final Duration _cacheExpiry = const Duration(minutes: 5);

  // Get case from cache
  CourtCase? get(String id) {
    final timestamp = _cacheTimestamps[id];
    if (timestamp == null) return null;

    // Check if cache has expired
    if (DateTime.now().difference(timestamp) > _cacheExpiry) {
      _remove(id);
      return null;
    }

    return _cache[id];
  }

  // Store case in cache
  void set(String id, CourtCase courtCase) {
    _cache[id] = courtCase;
    _cacheTimestamps[id] = DateTime.now();
    debugPrint('💾 Cached case: $id');
  }

  // Store multiple cases
  void setAll(List<CourtCase> cases) {
    for (final case_ in cases) {
      set(case_.id, case_);
    }
    debugPrint('💾 Cached ${cases.length} cases');
  }

  // Remove case from cache
  void _remove(String id) {
    _cache.remove(id);
    _cacheTimestamps.remove(id);
    debugPrint('🗑️ Removed from cache: $id');
  }

  // Clear all cache
  void clear() {
    _cache.clear();
    _cacheTimestamps.clear();
    debugPrint('🧹 Cache cleared');
  }

  // Get cache statistics
  Map<String, dynamic> getStats() {
    return {
      'size': _cache.length,
      'expired': _cacheTimestamps.entries
          .where(
            (entry) => DateTime.now().difference(entry.value) > _cacheExpiry,
          )
          .length,
    };
  }
}
