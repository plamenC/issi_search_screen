import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/court_case.dart';
import '../../infrastructure/repositories/court_case_repository.dart';

part 'search_provider.g.dart';

class SearchState {
  final List<CourtCase> searchResults;
  final List<String> availableCaseTypes;
  final String caseNumber;
  final String year;
  final String caseType;
  final bool isLoading;
  final bool isDropdownOpen;
  final bool isTextFieldReadOnly;
  final bool shouldShowAllOptions;
  final Map<String, CourtCase> databaseCases;

  const SearchState({
    required this.searchResults,
    required this.availableCaseTypes,
    required this.caseNumber,
    required this.year,
    required this.caseType,
    required this.isLoading,
    required this.isDropdownOpen,
    required this.isTextFieldReadOnly,
    required this.shouldShowAllOptions,
    required this.databaseCases,
  });

  SearchState copyWith({
    List<CourtCase>? searchResults,
    List<String>? availableCaseTypes,
    String? caseNumber,
    String? year,
    String? caseType,
    bool? isLoading,
    bool? isDropdownOpen,
    bool? isTextFieldReadOnly,
    bool? shouldShowAllOptions,
    Map<String, CourtCase>? databaseCases,
  }) {
    return SearchState(
      searchResults: searchResults ?? this.searchResults,
      availableCaseTypes: availableCaseTypes ?? this.availableCaseTypes,
      caseNumber: caseNumber ?? this.caseNumber,
      year: year ?? this.year,
      caseType: caseType ?? this.caseType,
      isLoading: isLoading ?? this.isLoading,
      isDropdownOpen: isDropdownOpen ?? this.isDropdownOpen,
      isTextFieldReadOnly: isTextFieldReadOnly ?? this.isTextFieldReadOnly,
      shouldShowAllOptions: shouldShowAllOptions ?? this.shouldShowAllOptions,
      databaseCases: databaseCases ?? this.databaseCases,
    );
  }

  bool get hasSearchCriteria =>
      caseNumber.isNotEmpty || year.isNotEmpty || caseType.isNotEmpty;
}

@riverpod
class SearchNotifier extends _$SearchNotifier {
  late final CourtCaseRepository _repository;
  final TextEditingController caseNumberController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final FocusNode caseNumberFocusNode = FocusNode();
  final FocusNode yearFocusNode = FocusNode();
  final FocusNode dropdownFocusNode = FocusNode();
  TextEditingController? autocompleteTextController;
  FocusNode? autocompleteFocusNode;

  @override
  SearchState build() {
    _repository = CourtCaseRepository();

    // Initialize with loading state first
    final initialState = const SearchState(
      searchResults: [],
      availableCaseTypes: [],
      caseNumber: '',
      year: '',
      caseType: '',
      isLoading: true, // Start with loading true
      isDropdownOpen: false,
      isTextFieldReadOnly: true,
      shouldShowAllOptions: false,
      databaseCases: {},
    );

    // Set the state first
    state = initialState;

    // Then perform async operations
    _loadCaseTypesFromDatabase();
    _performSearch();

    return initialState;
  }

  Future<void> _loadCaseTypesFromDatabase() async {
    try {
      debugPrint('🔄 Loading case types from database...');
      final caseTypes = await _repository.getAllowedCaseTypes();
      state = state.copyWith(availableCaseTypes: caseTypes);
      debugPrint('✅ Loaded ${caseTypes.length} case types: $caseTypes');
    } catch (e) {
      debugPrint('❌ Error loading case types: $e');
      state = state.copyWith(
        availableCaseTypes: [
          'civil',
          'criminal',
          'family',
          'commercial',
          'administrative',
        ],
      );
    }
  }

  Future<void> _performSearch() async {
    state = state.copyWith(isLoading: true);

    try {
      final List<Map<String, dynamic>> dbResultsWithFollows = await _repository
          .searchCourtCasesWithFollowStatus(
            query: state.caseNumber.isNotEmpty ? state.caseNumber : null,
            caseType: state.caseType.isNotEmpty ? state.caseType : null,
          );

      final updatedDatabaseCases = Map<String, CourtCase>.from(
        state.databaseCases,
      );
      final List<CourtCase> entities = dbResultsWithFollows
          .map((jsonData) {
            final dbCase = CourtCase.fromJson(jsonData);
            final isFollowed =
                jsonData['is_followed_by_device'] as bool? ?? false;

            // Store the original database case for detailed view
            updatedDatabaseCases[dbCase.id] = dbCase;

            // Year filtering
            if (state.year.isNotEmpty) {
              final filingYear = dbCase.filingDate.year.toString();
              if (filingYear != state.year) {
                return null;
              }
            }

            return CourtCase(
              id: dbCase.id,
              caseNumber: dbCase.caseNumber,
              title: dbCase.title,
              description: dbCase.description,
              caseType: dbCase.caseType,
              status: dbCase.status,
              courtPanel: dbCase.courtPanel,
              judgeName: dbCase.judgeName,
              filingDate: dbCase.filingDate,
              hearingDate: dbCase.hearingDate,
              createdAt: dbCase.createdAt,
              updatedAt: dbCase.updatedAt,
              hasUnreadNotifications: false,
              isFollowed: isFollowed,
            );
          })
          .where((case_) => case_ != null)
          .cast<CourtCase>()
          .toList();

      state = state.copyWith(
        searchResults: entities,
        databaseCases: updatedDatabaseCases,
        isLoading: false,
      );

      debugPrint('✅ Search completed: Found ${entities.length} cases');
    } catch (e) {
      debugPrint('❌ Error searching court cases: $e');
      state = state.copyWith(searchResults: [], isLoading: false);
    }
  }

  void search() {
    final caseNumberValue = caseNumberController.text;
    final yearValue = yearController.text;
    final caseTypeValue = autocompleteTextController?.text ?? '';

    state = state.copyWith(
      caseNumber: caseNumberValue,
      year: yearValue,
      caseType: caseTypeValue,
    );

    debugPrint('PLAMEN: Search button pressed');
    debugPrint('PLAMEN: Номер: $caseNumberValue');
    debugPrint('PLAMEN: Година: $yearValue');
    debugPrint('PLAMEN: Тип дело: $caseTypeValue');

    if (state.isDropdownOpen) {
      closeDropdown();
    }

    _performSearch();
  }

  void clearSearch() {
    caseNumberController.clear();
    yearController.clear();
    if (autocompleteTextController != null) {
      autocompleteTextController!.clear();
    }

    state = state.copyWith(
      caseNumber: '',
      year: '',
      caseType: '',
      isDropdownOpen: false,
      isTextFieldReadOnly: true,
      shouldShowAllOptions: false,
    );

    caseNumberFocusNode.unfocus();
    yearFocusNode.unfocus();
    dropdownFocusNode.unfocus();
    if (autocompleteFocusNode != null) {
      autocompleteFocusNode!.unfocus();
    }

    debugPrint('🧹 Search form cleared - all fields reset');
    _performSearch();
  }

  void onDropdownTap() {
    debugPrint('PLAMEN:✅ onDropdownTap() called');
    state = state.copyWith(
      isDropdownOpen: true,
      isTextFieldReadOnly: true,
      shouldShowAllOptions: true,
    );
    if (!dropdownFocusNode.hasFocus) {
      dropdownFocusNode.requestFocus();
    }
  }

  void closeDropdown() {
    debugPrint('PLAMEN:❌ closeDropdown() called');
    state = state.copyWith(
      isDropdownOpen: false,
      isTextFieldReadOnly: true,
      shouldShowAllOptions: false,
    );
    if (autocompleteFocusNode != null) {
      autocompleteFocusNode!.unfocus();
    }
    dropdownFocusNode.unfocus();
  }

  void selectCaseType(String selection) {
    debugPrint('PLAMEN:Selected case type: $selection');
    if (autocompleteTextController != null) {
      autocompleteTextController!.text = selection;
    }
    state = state.copyWith(caseType: selection);
    closeDropdown();
  }

  void onOtherFieldTap(FocusNode focusNode) {
    debugPrint('PLAMEN:📱 Other field tapped - closing dropdown');
    closeDropdown();
    focusNode.requestFocus();
  }

  List<String> getFilteredCaseTypes(String input) {
    if (input.isEmpty) return state.availableCaseTypes;
    return state.availableCaseTypes
        .where((type) => type.toLowerCase().contains(input.toLowerCase()))
        .toList();
  }

  Future<void> toggleFollowCase(String caseId) async {
    try {
      debugPrint('🔄 Toggling follow status for case: $caseId');

      final caseIndex = state.searchResults.indexWhere(
        (case_) => case_.id == caseId,
      );

      if (caseIndex == -1) {
        debugPrint('❌ Case not found in current results: $caseId');
        return;
      }

      final currentCase = state.searchResults[caseIndex];
      final newFollowStatus = !currentCase.isFollowed;

      await _repository.toggleFollowCase(caseId);

      final updatedCase = currentCase.copyWith(isFollowed: newFollowStatus);
      final updatedList = List<CourtCase>.from(state.searchResults);
      updatedList[caseIndex] = updatedCase;

      state = state.copyWith(searchResults: updatedList);

      debugPrint('✅ Follow status updated: $caseId -> $newFollowStatus');
    } catch (e) {
      debugPrint('❌ Error toggling follow status: $e');
    }
  }

  CourtCase? getFullCaseDetails(String caseId) {
    return state.databaseCases[caseId];
  }

  Future<bool> getCurrentFollowStatus(String caseId) async {
    try {
      debugPrint('🔄 Getting current follow status for case: $caseId');
      final result = await _repository.searchCourtCasesWithFollowStatus(
        query: null,
        caseType: null,
      );

      final caseData = result.firstWhere(
        (jsonData) => jsonData['id'] == caseId,
        orElse: () => <String, dynamic>{},
      );

      if (caseData.isNotEmpty) {
        final isFollowed = caseData['is_followed_by_device'] as bool? ?? false;
        debugPrint('✅ Current follow status for case $caseId: $isFollowed');
        return isFollowed;
      }

      debugPrint('⚠️ Case not found in database: $caseId');
      return false;
    } catch (e) {
      debugPrint('❌ Error getting follow status: $e');
      return false;
    }
  }

  Future<void> refreshSearchResults() async {
    debugPrint('🔄 Refreshing search results to get latest follow status');
    await _performSearch();
  }
}
