import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/theme/app_colors.dart';
import '../../application/providers/search_provider.dart';
import '../../application/providers/my_court_cases_provider.dart';
import '../../domain/models/court_case.dart';
import '../widgets/court_case_card.dart';

class CourtCasesScreen extends ConsumerStatefulWidget {
  const CourtCasesScreen({super.key});

  @override
  ConsumerState<CourtCasesScreen> createState() => _CourtCasesScreenState();
}

class _CourtCasesScreenState extends ConsumerState<CourtCasesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _previousIndex = 0; // Track previous tab index

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Add listener to refresh data when tab changes
    _tabController.addListener(() {
      final currentIndex = _tabController.index;
      if (currentIndex != _previousIndex) {
        debugPrint('🔄 Tab changed from $_previousIndex to $currentIndex');
        _onTabChanged(currentIndex);
        _previousIndex = currentIndex;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    if (index == 0) {
      // Search tab selected
      debugPrint('🔄 Search tab selected, refreshing search results');
      ref.read(searchNotifierProvider.notifier).refreshSearchResults();
    } else if (index == 1) {
      // My Court Cases tab selected
      debugPrint('🔄 My Court Cases tab selected, refreshing data');
      ref.read(myCourtCasesNotifierProvider.notifier).refreshFollowedCases();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(top: 32, bottom: 20),
            child: Row(
              children: [
                Icon(
                  Icons.gavel_outlined,
                  size: 32,
                  color: AppColors.primaryIndigo,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Дела',
                    style: TextStyle(
                      fontFamily: 'DejaVu Sans',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryIndigo,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.primaryIndigo,
              ),
              labelColor: AppColors.textWhite,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: TextStyle(
                fontFamily: 'DejaVu Sans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: 'DejaVu Sans',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(text: 'Търсене'),
                Tab(text: 'Моите дела'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildSearchTab(), _buildMyCourtCasesTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTab() {
    final searchState = ref.watch(searchNotifierProvider);
    final searchNotifier = ref.read(searchNotifierProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Form
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 4),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: TextField(
                          controller: searchNotifier.caseNumberController,
                          focusNode: searchNotifier.caseNumberFocusNode,
                          onTap: () {
                            debugPrint(
                              'PLAMEN:📱 Case number field tapped - closing dropdown',
                            );
                            searchNotifier.onOtherFieldTap(
                              searchNotifier.caseNumberFocusNode,
                            );
                          },
                          onTapOutside: (e) {
                            searchNotifier.caseNumberFocusNode.unfocus();
                          },
                          onSubmitted: (value) {
                            debugPrint('Plamen:Дело номер: $value');
                          },
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            letterSpacing: 0.5,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Номер',
                            labelStyle: TextStyle(color: AppColors.textGrey),
                            floatingLabelStyle: TextStyle(
                              color: AppColors.primaryIndigo,
                            ),
                            hintText: '...',
                            hintStyle: TextStyle(color: AppColors.textDark),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: AppColors.textGrey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                color: AppColors.primaryIndigo,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(
                              left: 16,
                              top: 4,
                              bottom: 4,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Flexible(
                        flex: 1,
                        child: TextField(
                          controller: searchNotifier.yearController,
                          focusNode: searchNotifier.yearFocusNode,
                          onTap: () {
                            debugPrint(
                              'PLAMEN:📅 Year field tapped - closing dropdown',
                            );
                            searchNotifier.onOtherFieldTap(
                              searchNotifier.yearFocusNode,
                            );
                          },
                          onTapOutside: (e) {
                            searchNotifier.yearFocusNode.unfocus();
                          },
                          onSubmitted: (value) {
                            debugPrint('PLAMEN:Година: $value');
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            letterSpacing: 0.5,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Година',
                            labelStyle: TextStyle(color: AppColors.textGrey),
                            floatingLabelStyle: TextStyle(
                              color: AppColors.primaryIndigo,
                            ),
                            hintText: DateTime.now().year.toString(),
                            hintStyle: TextStyle(color: AppColors.textDark),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: AppColors.textGrey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                color: AppColors.primaryIndigo,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(
                              left: 16,
                              top: 4,
                              bottom: 4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (searchState.shouldShowAllOptions) {
                            debugPrint(
                              'PLAMEN:📋 Showing all options (${searchState.availableCaseTypes.length} items)',
                            );
                            return searchState.availableCaseTypes;
                          }
                          debugPrint(
                            'PLAMEN:📋 Filtering options for: "${textEditingValue.text}"',
                          );
                          return searchNotifier.getFilteredCaseTypes(
                            textEditingValue.text,
                          );
                        },
                        fieldViewBuilder:
                            (
                              context,
                              textEditingController,
                              focusNode,
                              onFieldSubmitted,
                            ) {
                              searchNotifier.autocompleteTextController =
                                  textEditingController;
                              searchNotifier.autocompleteFocusNode = focusNode;

                              return TextField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                readOnly: searchState.isTextFieldReadOnly,
                                onTap: () {
                                  debugPrint(
                                    'PLAMEN:👆 Autocomplete field tapped',
                                  );
                                  searchNotifier.onDropdownTap();
                                },
                                onTapOutside: (e) {
                                  focusNode.unfocus();
                                  searchNotifier.closeDropdown();
                                },
                                onSubmitted: (value) {
                                  debugPrint('PLAMEN:Тип дело: $value');
                                  searchNotifier.selectCaseType(value);
                                },
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                  letterSpacing: 0.5,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Тип дело',
                                  labelStyle: TextStyle(
                                    color: AppColors.textGrey,
                                  ),
                                  floatingLabelStyle: TextStyle(
                                    color: AppColors.primaryIndigo,
                                  ),
                                  hintText: 'Изберете тип дело',
                                  hintStyle: TextStyle(
                                    color: AppColors.textDark,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide(
                                      color: AppColors.textGrey,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide(
                                      color: AppColors.primaryIndigo,
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                    left: 16,
                                    top: 4,
                                    bottom: 4,
                                  ),
                                  suffixIcon: Consumer(
                                    builder: (context, ref, child) {
                                      final currentState = ref.watch(
                                        searchNotifierProvider,
                                      );
                                      return GestureDetector(
                                        onTap: () {
                                          debugPrint(
                                            'PLAMEN:👆 Arrow icon tapped - toggling dropdown',
                                          );
                                          if (currentState.isDropdownOpen) {
                                            searchNotifier.closeDropdown();
                                          } else {
                                            searchNotifier.onDropdownTap();
                                          }
                                        },
                                        child: Icon(
                                          currentState.isDropdownOpen
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                          color: AppColors.textGrey,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                        onSelected: (String selection) {
                          debugPrint('PLAMEN:Selected case type: $selection');
                          searchNotifier.selectCaseType(selection);
                        },
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: searchNotifier.search,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            'Търси',
                            style: TextStyle(
                              fontFamily: 'DejaVu Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textWhite,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Clear button row
                Consumer(
                  builder: (context, ref, child) {
                    final currentState = ref.watch(searchNotifierProvider);
                    if (currentState.hasSearchCriteria) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: searchNotifier.clearSearch,
                              child: Text(
                                'Премахни',
                                style: TextStyle(
                                  fontFamily: 'DejaVu Sans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),

          // Search Results
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final currentState = ref.watch(searchNotifierProvider);

                if (currentState.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryIndigo,
                      ),
                    ),
                  );
                }

                if (currentState.searchResults.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_outlined,
                          size: 64,
                          color: AppColors.textLight,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Няма намерени дела',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Опитайте с различни критерии за търсене',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  itemCount: currentState.searchResults.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final courtCase = currentState.searchResults[index];
                    return CourtCaseCard(
                      caseNumber: courtCase.caseNumber,
                      year: courtCase.filingDate.year.toString(),
                      courtCaseType: courtCase.caseType,
                      status: courtCase.status,
                      hasUnreadNotifications: courtCase.hasUnreadNotifications,
                      isFollowed: courtCase.isFollowed,
                      onFollowToggle: () {
                        _showFollowConfirmationDialog(courtCase);
                      },
                      onTap: () {
                        debugPrint(
                          '🔍 Card tapped for case: ${courtCase.caseNumber}',
                        );
                        _showCaseDetails(courtCase);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyCourtCasesTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtitle
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              'Следваните от вас дела',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ),

          // Content
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final myCourtCasesState = ref.watch(
                  myCourtCasesNotifierProvider,
                );

                if (myCourtCasesState.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryIndigo,
                      ),
                    ),
                  );
                }

                if (myCourtCasesState.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Грешка при зареждане',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          myCourtCasesState.errorMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref
                              .read(myCourtCasesNotifierProvider.notifier)
                              .loadFollowedCases(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryIndigo,
                          ),
                          child: Text(
                            'Опитай отново',
                            style: TextStyle(color: AppColors.textWhite),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (myCourtCasesState.followedCases.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_open_outlined,
                          size: 64,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Няма следвани дела',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Започнете да следвате дела от екрана за търсене',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            _tabController.animateTo(0); // Switch to search tab
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Навигирайте към търсенето'),
                                backgroundColor: AppColors.primaryIndigo,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryIndigo,
                          ),
                          child: Text(
                            'Разбирам',
                            style: TextStyle(color: AppColors.textWhite),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Display followed cases
                return RefreshIndicator(
                  onRefresh: () => ref
                      .read(myCourtCasesNotifierProvider.notifier)
                      .refreshFollowedCases(),
                  color: AppColors.primaryIndigo,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: myCourtCasesState.followedCases.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final courtCase = myCourtCasesState.followedCases[index];
                      return CourtCaseCard(
                        caseNumber: courtCase.caseNumber,
                        year: courtCase.filingDate.year.toString(),
                        courtCaseType: courtCase.caseType,
                        status: courtCase.status,
                        hasUnreadNotifications:
                            courtCase.hasUnreadNotifications,
                        isFollowed: true, // Always true in this screen
                        onFollowToggle: () {
                          _showUnfollowConfirmationDialog(courtCase);
                        },
                        onTap: () {
                          _showCaseDetails(courtCase);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFollowConfirmationDialog(CourtCase courtCase) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Следване на дело',
          style: TextStyle(
            fontFamily: 'DejaVu Sans',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryIndigo,
          ),
        ),
        content: Text(
          'Искате ли да следите това дело?\n\nДело № ${courtCase.caseNumber} / ${courtCase.filingDate.year}',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textDark,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Откажи',
              style: TextStyle(
                fontFamily: 'DejaVu Sans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textGrey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(searchNotifierProvider.notifier)
                  .toggleFollowCase(courtCase.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLightGreenAlt,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              courtCase.isFollowed ? 'Спри следването' : 'Следвай',
              style: TextStyle(
                fontFamily: 'DejaVu Sans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUnfollowConfirmationDialog(CourtCase courtCase) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Премахване от следваните',
          style: TextStyle(
            fontFamily: 'DejaVu Sans',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryIndigo,
          ),
        ),
        content: Text(
          'Искате ли да премахнете това дело от следваните?\n\nДело № ${courtCase.caseNumber} / ${courtCase.filingDate.year}',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textDark,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Откажи',
              style: TextStyle(
                fontFamily: 'DejaVu Sans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textGrey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(searchNotifierProvider.notifier)
                  .toggleFollowCase(courtCase.id);
              // Also refresh the followed cases list to keep it in sync
              await ref
                  .read(myCourtCasesNotifierProvider.notifier)
                  .refreshFollowedCases();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(
              'Премахни',
              style: TextStyle(
                fontFamily: 'DejaVu Sans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCaseDetails(CourtCase courtCase) async {
    debugPrint('📋 Showing case details for: ${courtCase.caseNumber}');

    // Get full case details from database
    final fullCase = ref
        .read(searchNotifierProvider.notifier)
        .getFullCaseDetails(courtCase.id);

    if (fullCase == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Не могат да се заредят подробностите за делото'),
        ),
      );
      return;
    }

    // Get current follow status from Supabase
    final currentFollowStatus = await ref
        .read(searchNotifierProvider.notifier)
        .getCurrentFollowStatus(courtCase.id);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          fullCase.title,
          style: TextStyle(
            fontFamily: 'DejaVu Sans',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryIndigo,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Номер дело', fullCase.caseNumber),
              _buildStatusRow('Статус', fullCase.status),
              _buildDetailRow('Тип дело', fullCase.caseType),
              _buildDetailRow('Съд', fullCase.courtPanel),
              if (fullCase.judgeName != null)
                _buildDetailRow('Съдия', fullCase.judgeName!),
              _buildDetailRow(
                'Дата на подаване',
                _formatDate(fullCase.filingDate),
              ),
              if (fullCase.hearingDate != null)
                _buildDetailRow(
                  'Дата на заседание',
                  _formatDate(fullCase.hearingDate!),
                ),
              if (fullCase.description != null &&
                  fullCase.description!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Описание:',
                  style: TextStyle(
                    fontFamily: 'DejaVu Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryIndigo,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fullCase.description!,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textDark,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context); // Close current dialog first
                      if (currentFollowStatus) {
                        _showUnfollowConfirmationDialog(courtCase);
                      } else {
                        _showFollowConfirmationDialog(courtCase);
                      }
                    },
                    icon: Icon(
                      currentFollowStatus
                          ? Icons.notifications
                          : Icons.notifications_outlined,
                      size: 16,
                      color: currentFollowStatus
                          ? AppColors.primaryIndigo
                          : AppColors.textGrey,
                    ),
                  ),
                  Text(
                    currentFollowStatus ? 'Следва се' : 'Следвай делото',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Затвори',
              style: TextStyle(
                fontFamily: 'DejaVu Sans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontFamily: 'DejaVu Sans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryIndigo,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontFamily: 'DejaVu Sans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryIndigo,
              ),
            ),
          ),
          Expanded(child: _buildStatusChip(value)),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'active':
        color = AppColors.materialGreen;
        break;
      case 'pending':
        color = AppColors.materialOrange;
        break;
      case 'closed':
        color = AppColors.materialGrey;
        break;
      case 'appealed':
        color = AppColors.materialPurple;
        break;
      default:
        color = AppColors.materialBlue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
