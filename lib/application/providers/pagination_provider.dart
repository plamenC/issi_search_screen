import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/court_case.dart';
import '../../infrastructure/repositories/court_case_repository.dart';

part 'pagination_provider.g.dart';

class PaginationState {
  final List<CourtCase> items;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final String? errorMessage;

  const PaginationState({
    required this.items,
    required this.isLoading,
    required this.hasMore,
    required this.currentPage,
    this.errorMessage,
  });

  PaginationState copyWith({
    List<CourtCase>? items,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
    String? errorMessage,
  }) {
    return PaginationState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@riverpod
class PaginatedCourtCases extends _$PaginatedCourtCases {
  late final CourtCaseRepository _repository;
  static const int _pageSize = 20;

  @override
  PaginationState build() {
    _repository = CourtCaseRepository();
    return const PaginationState(
      items: [],
      isLoading: false,
      hasMore: true,
      currentPage: 0,
    );
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      debugPrint('🔄 Loading page ${state.currentPage + 1}...');

      // Simulate pagination - in real app, you'd pass offset/limit to repository
      final allCases = await _repository.searchCourtCases();
      final startIndex = state.currentPage * _pageSize;
      final endIndex = startIndex + _pageSize;

      if (startIndex >= allCases.length) {
        state = state.copyWith(isLoading: false, hasMore: false);
        return;
      }

      final newItems = allCases.sublist(
        startIndex,
        endIndex > allCases.length ? allCases.length : endIndex,
      );

      state = state.copyWith(
        items: [...state.items, ...newItems],
        isLoading: false,
        currentPage: state.currentPage + 1,
        hasMore: endIndex < allCases.length,
      );

      debugPrint(
        '✅ Loaded ${newItems.length} items, total: ${state.items.length}',
      );
    } catch (e) {
      debugPrint('❌ Error loading page: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load cases: $e',
      );
    }
  }

  Future<void> refresh() async {
    state = const PaginationState(
      items: [],
      isLoading: false,
      hasMore: true,
      currentPage: 0,
    );
    await loadNextPage();
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
