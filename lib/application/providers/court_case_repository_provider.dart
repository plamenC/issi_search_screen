import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/court_case.dart';
import '../../infrastructure/repositories/court_case_repository.dart';

part 'court_case_repository_provider.g.dart';

// Pure data operations provider
@riverpod
class CourtCaseRepositoryNotifier extends _$CourtCaseRepositoryNotifier {
  late final CourtCaseRepository _repository;

  @override
  Future<List<CourtCase>> build() async {
    _repository = CourtCaseRepository();
    return _loadAllCases();
  }

  Future<List<CourtCase>> _loadAllCases() async {
    try {
      debugPrint('🔄 Loading all court cases...');
      final cases = await _repository.searchCourtCases();
      debugPrint('✅ Loaded ${cases.length} court cases');
      return cases;
    } catch (e) {
      debugPrint('❌ Error loading court cases: $e');
      return [];
    }
  }

  Future<List<CourtCase>> searchCases({
    String? query,
    String? caseType,
    String? status,
    String? year,
  }) async {
    try {
      debugPrint('🔄 Searching court cases...');
      final cases = await _repository.searchCourtCases(
        query: query,
        caseType: caseType,
        status: status,
      );

      // Apply year filter if provided
      if (year != null && year.isNotEmpty) {
        return cases
            .where((case_) => case_.filingDate.year.toString() == year)
            .toList();
      }

      debugPrint('✅ Found ${cases.length} cases');
      return cases;
    } catch (e) {
      debugPrint('❌ Error searching court cases: $e');
      return [];
    }
  }

  Future<List<CourtCase>> getFollowedCases() async {
    try {
      debugPrint('🔄 Loading followed court cases...');
      final cases = await _repository.getFollowedCourtCases();
      debugPrint('✅ Loaded ${cases.length} followed cases');
      return cases;
    } catch (e) {
      debugPrint('❌ Error loading followed cases: $e');
      return [];
    }
  }

  Future<void> toggleFollowCase(String caseId) async {
    try {
      debugPrint('🔄 Toggling follow status for case: $caseId');
      await _repository.toggleFollowCase(caseId);
      debugPrint('✅ Follow status toggled for case: $caseId');

      // Invalidate the followed cases provider
      ref.invalidate(followedCasesProvider);
    } catch (e) {
      debugPrint('❌ Error toggling follow status: $e');
      throw Exception('Failed to toggle follow status: $e');
    }
  }

  Future<List<String>> getCaseTypes() async {
    try {
      debugPrint('🔄 Loading case types...');
      final types = await _repository.getAllowedCaseTypes();
      debugPrint('✅ Loaded ${types.length} case types');
      return types;
    } catch (e) {
      debugPrint('❌ Error loading case types: $e');
      return ['civil', 'criminal', 'family', 'commercial', 'administrative'];
    }
  }

  Future<List<String>> getStatuses() async {
    try {
      debugPrint('🔄 Loading statuses...');
      final statuses = await _repository.getAllowedStatuses();
      debugPrint('✅ Loaded ${statuses.length} statuses');
      return statuses;
    } catch (e) {
      debugPrint('❌ Error loading statuses: $e');
      return ['pending', 'active', 'closed', 'appealed'];
    }
  }
}

// Computed providers for derived state
@riverpod
List<CourtCase> filteredCases(
  // ignore: deprecated_member_use
  FilteredCasesRef ref, {
  String? query,
  String? caseType,
  String? status,
  String? year,
}) {
  final casesAsync = ref.watch(courtCaseRepositoryNotifierProvider);

  return casesAsync.when(
    data: (cases) {
      var filtered = cases;

      if (query != null && query.isNotEmpty) {
        filtered = filtered
            .where(
              (case_) =>
                  case_.caseNumber.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  case_.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }

      if (caseType != null && caseType.isNotEmpty) {
        filtered = filtered
            .where(
              (case_) => case_.caseType.toLowerCase() == caseType.toLowerCase(),
            )
            .toList();
      }

      if (status != null && status.isNotEmpty) {
        filtered = filtered
            .where(
              (case_) => case_.status.toLowerCase() == status.toLowerCase(),
            )
            .toList();
      }

      if (year != null && year.isNotEmpty) {
        filtered = filtered
            .where((case_) => case_.filingDate.year.toString() == year)
            .toList();
      }

      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

@riverpod
Future<List<CourtCase>> followedCases(
  // ignore: deprecated_member_use
  FollowedCasesRef ref,
) {
  final repository = ref.watch(courtCaseRepositoryNotifierProvider.notifier);
  return repository.getFollowedCases();
}
