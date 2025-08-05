import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/utils/debouncer.dart';
import '../../infrastructure/theme/app_colors.dart';

part 'search_ui_provider.g.dart';

class SearchUIState {
  final String caseNumber;
  final String year;
  final String caseType;
  final bool isDropdownOpen;
  final bool isTextFieldReadOnly;
  final bool shouldShowAllOptions;
  final List<String> availableCaseTypes;
  final bool isLoading;

  const SearchUIState({
    required this.caseNumber,
    required this.year,
    required this.caseType,
    required this.isDropdownOpen,
    required this.isTextFieldReadOnly,
    required this.shouldShowAllOptions,
    required this.availableCaseTypes,
    required this.isLoading,
  });

  SearchUIState copyWith({
    String? caseNumber,
    String? year,
    String? caseType,
    bool? isDropdownOpen,
    bool? isTextFieldReadOnly,
    bool? shouldShowAllOptions,
    List<String>? availableCaseTypes,
    bool? isLoading,
  }) {
    return SearchUIState(
      caseNumber: caseNumber ?? this.caseNumber,
      year: year ?? this.year,
      caseType: caseType ?? this.caseType,
      isDropdownOpen: isDropdownOpen ?? this.isDropdownOpen,
      isTextFieldReadOnly: isTextFieldReadOnly ?? this.isTextFieldReadOnly,
      shouldShowAllOptions: shouldShowAllOptions ?? this.shouldShowAllOptions,
      availableCaseTypes: availableCaseTypes ?? this.availableCaseTypes,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool get hasSearchCriteria =>
      caseNumber.isNotEmpty || year.isNotEmpty || caseType.isNotEmpty;
}

@riverpod
class SearchUINotifier extends _$SearchUINotifier {
  final TextEditingController caseNumberController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final FocusNode caseNumberFocusNode = FocusNode();
  final FocusNode yearFocusNode = FocusNode();
  final FocusNode dropdownFocusNode = FocusNode();
  TextEditingController? autocompleteTextController;
  FocusNode? autocompleteFocusNode;
  late final Debouncer _searchDebouncer;

  @override
  SearchUIState build() {
    _searchDebouncer = Debouncer();

    // Add listeners to controllers
    caseNumberController.addListener(_onCaseNumberChanged);
    yearController.addListener(_onYearChanged);

    return const SearchUIState(
      caseNumber: '',
      year: '',
      caseType: '',
      isDropdownOpen: false,
      isTextFieldReadOnly: true,
      shouldShowAllOptions: false,
      availableCaseTypes: [],
      isLoading: false,
    );
  }

  void _onCaseNumberChanged() {
    state = state.copyWith(caseNumber: caseNumberController.text);
  }

  void _onYearChanged() {
    state = state.copyWith(year: yearController.text);
  }

  void setCaseType(String caseType) {
    state = state.copyWith(caseType: caseType);
    if (autocompleteTextController != null) {
      autocompleteTextController!.text = caseType;
    }
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
    setCaseType(selection);
    closeDropdown();
  }

  void onOtherFieldTap(FocusNode focusNode) {
    debugPrint('PLAMEN:📱 Other field tapped - closing dropdown');
    closeDropdown();
    focusNode.requestFocus();
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
  }

  void setAvailableCaseTypes(List<String> types) {
    state = state.copyWith(availableCaseTypes: types);
  }

  List<String> getFilteredCaseTypes(String input) {
    if (input.isEmpty) return state.availableCaseTypes;
    return state.availableCaseTypes
        .where((type) => type.toLowerCase().contains(input.toLowerCase()))
        .toList();
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  @override
  void dispose() {
    _searchDebouncer.dispose();
    caseNumberController.dispose();
    yearController.dispose();
    caseNumberFocusNode.dispose();
    yearFocusNode.dispose();
    dropdownFocusNode.dispose();
  }
}
