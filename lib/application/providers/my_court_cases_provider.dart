import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/court_case.dart';
import '../../infrastructure/repositories/court_case_repository.dart';

part 'my_court_cases_provider.g.dart';

class MyCourtCasesState {
  final List<CourtCase> followedCases;
  final bool isLoading;
  final bool hasError;
  final String errorMessage;

  const MyCourtCasesState({
    required this.followedCases,
    required this.isLoading,
    required this.hasError,
    required this.errorMessage,
  });

  MyCourtCasesState copyWith({
    List<CourtCase>? followedCases,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
  }) {
    return MyCourtCasesState(
      followedCases: followedCases ?? this.followedCases,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@riverpod
class MyCourtCasesNotifier extends _$MyCourtCasesNotifier {
  late final CourtCaseRepository _repository;

  @override
  MyCourtCasesState build() {
    _repository = CourtCaseRepository();
    // Initialize with loading state first
    state = const MyCourtCasesState(
      followedCases: [],
      isLoading: true,
      hasError: false,
      errorMessage: '',
    );
    // Then load data asynchronously
    _loadFollowedCasesAsync();
    return state;
  }

  Future<void> _loadFollowedCasesAsync() async {
    try {
      debugPrint('🔄 Loading followed court cases...');
      final cases = await _repository.getFollowedCourtCases();
      state = state.copyWith(followedCases: cases, isLoading: false);
      debugPrint('✅ Loaded ${cases.length} followed cases');
    } catch (e) {
      debugPrint('❌ Error loading followed cases: $e');
      state = state.copyWith(
        hasError: true,
        errorMessage: 'Грешка при зареждане на следваните дела: $e',
        followedCases: [],
        isLoading: false,
      );
    }
  }

  Future<void> loadFollowedCases() async {
    state = state.copyWith(isLoading: true, hasError: false, errorMessage: '');

    try {
      debugPrint('🔄 Loading followed court cases...');
      final cases = await _repository.getFollowedCourtCases();
      state = state.copyWith(followedCases: cases, isLoading: false);
      debugPrint('✅ Loaded ${cases.length} followed cases');
    } catch (e) {
      debugPrint('❌ Error loading followed cases: $e');
      state = state.copyWith(
        hasError: true,
        errorMessage: 'Грешка при зареждане на следваните дела: $e',
        followedCases: [],
        isLoading: false,
      );
    }
  }

  Future<void> unfollowCase(String caseId) async {
    try {
      debugPrint('🔄 Unfollowing case: $caseId');
      await _repository.toggleFollowCase(caseId);

      // Remove from local list
      final updatedCases = state.followedCases
          .where((case_) => case_.id != caseId)
          .toList();
      state = state.copyWith(followedCases: updatedCases);

      debugPrint('✅ Successfully unfollowed case: $caseId');
    } catch (e) {
      debugPrint('❌ Error unfollowing case: $e');
    }
  }

  Future<void> refreshFollowedCases() async {
    await loadFollowedCases();
  }

  CourtCase? getCaseById(String caseId) {
    try {
      return state.followedCases.firstWhere((case_) => case_.id == caseId);
    } catch (e) {
      return null;
    }
  }
}
