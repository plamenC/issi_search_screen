import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/court_case.dart';
import '../../infrastructure/repositories/court_case_repository.dart';

part 'court_case_provider.g.dart';

// State class to hold all the observable data
class CourtCaseState {
  final List<CourtCase> courtCases;
  final List<String> statusOptions;
  final List<String> caseTypeOptions;
  final String searchQuery;
  final String selectedStatus;
  final String selectedCaseType;
  final bool isLoading;

  const CourtCaseState({
    required this.courtCases,
    required this.statusOptions,
    required this.caseTypeOptions,
    required this.searchQuery,
    required this.selectedStatus,
    required this.selectedCaseType,
    required this.isLoading,
  });

  CourtCaseState copyWith({
    List<CourtCase>? courtCases,
    List<String>? statusOptions,
    List<String>? caseTypeOptions,
    String? searchQuery,
    String? selectedStatus,
    String? selectedCaseType,
    bool? isLoading,
  }) {
    return CourtCaseState(
      courtCases: courtCases ?? this.courtCases,
      statusOptions: statusOptions ?? this.statusOptions,
      caseTypeOptions: caseTypeOptions ?? this.caseTypeOptions,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedCaseType: selectedCaseType ?? this.selectedCaseType,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@riverpod
class CourtCaseNotifier extends _$CourtCaseNotifier {
  late final CourtCaseRepository _repository;

  @override
  CourtCaseState build() {
    _repository = CourtCaseRepository();
    _loadOptions();
    _loadCourtCases();
    return const CourtCaseState(
      courtCases: [],
      statusOptions: ['All'],
      caseTypeOptions: ['All'],
      searchQuery: '',
      selectedStatus: '',
      selectedCaseType: '',
      isLoading: true,
    );
  }

  Future<void> _loadCourtCases() async {
    try {
      state = state.copyWith(isLoading: true);
      debugPrint('🔄 Loading court cases...');

      final cases = await _repository.searchCourtCases(
        query: state.searchQuery.isEmpty ? null : state.searchQuery,
        status: state.selectedStatus == 'All' || state.selectedStatus.isEmpty
            ? null
            : state.selectedStatus,
        caseType:
            state.selectedCaseType == 'All' || state.selectedCaseType.isEmpty
            ? null
            : state.selectedCaseType,
      );

      debugPrint('✅ Loaded ${cases.length} court cases');
      state = state.copyWith(courtCases: cases, isLoading: false);
    } catch (e) {
      debugPrint('❌ Error loading court cases: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> searchCourtCases(String query) async {
    state = state.copyWith(searchQuery: query);
    await _loadCourtCases();
  }

  Future<void> filterByStatus(String status) async {
    state = state.copyWith(selectedStatus: status);
    await _loadCourtCases();
  }

  Future<void> filterByCaseType(String caseType) async {
    state = state.copyWith(selectedCaseType: caseType);
    await _loadCourtCases();
  }

  Future<void> clearFilters() async {
    state = state.copyWith(
      searchQuery: '',
      selectedStatus: 'All',
      selectedCaseType: 'All',
    );
    await _loadCourtCases();
  }

  Future<void> createCourtCase(CourtCase courtCase) async {
    try {
      await _repository.createCourtCase(courtCase);
      await _loadCourtCases();
    } catch (e) {
      debugPrint('❌ Error creating court case: $e');
      rethrow;
    }
  }

  Future<void> updateCourtCase(CourtCase courtCase) async {
    try {
      await _repository.updateCourtCase(courtCase);
      await _loadCourtCases();
    } catch (e) {
      debugPrint('❌ Error updating court case: $e');
      rethrow;
    }
  }

  Future<void> deleteCourtCase(String id) async {
    try {
      await _repository.deleteCourtCase(id);
      await _loadCourtCases();
    } catch (e) {
      debugPrint('❌ Error deleting court case: $e');
      rethrow;
    }
  }

  Future<CourtCase?> getCourtCaseById(String id) async {
    try {
      return await _repository.getCourtCaseById(id);
    } catch (e) {
      debugPrint('❌ Error getting court case by ID: $e');
      return null;
    }
  }

  Future<Map<String, int>> getCaseStatusCounts() async {
    try {
      return await _repository.getCaseStatusCounts();
    } catch (e) {
      debugPrint('❌ Error getting case status counts: $e');
      return {};
    }
  }

  Future<void> _loadOptions() async {
    try {
      // Load status options
      final statuses = await _repository.getAllowedStatuses();
      state = state.copyWith(statusOptions: ['All', ...statuses]);
      debugPrint('✅ Loaded statuses: $statuses');

      // Load case type options
      final caseTypes = await _repository.getAllowedCaseTypes();
      state = state.copyWith(caseTypeOptions: ['All', ...caseTypes]);
      debugPrint('✅ Loaded case types: $caseTypes');
    } catch (e) {
      debugPrint('❌ Error loading options: $e');
      // Set fallback values
      state = state.copyWith(
        statusOptions: ['All', 'pending', 'active', 'closed', 'appealed'],
        caseTypeOptions: [
          'All',
          'civil',
          'criminal',
          'family',
          'commercial',
          'administrative',
        ],
      );
    }
  }
}
