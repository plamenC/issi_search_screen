import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/court_case.dart';
import '../../infrastructure/theme/app_colors.dart';
import 'court_case_card.dart';
import 'loading_state.dart';
import 'error_state.dart';

class CourtCaseList extends ConsumerWidget {
  final List<CourtCase> cases;
  final Future<void> Function()? onRefresh;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final String emptyMessage;
  final String emptySubtitle;

  const CourtCaseList({
    super.key,
    required this.cases,
    this.onRefresh,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.emptyMessage = 'Няма намерени дела',
    this.emptySubtitle = 'Опитайте с различни критерии за търсене',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isLoading) {
      return const LoadingState(message: 'Зареждане на дела...');
    }

    if (errorMessage != null) {
      return ErrorState(message: errorMessage!, onRetry: onRetry);
    }

    if (cases.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      color: AppColors.primaryIndigo,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: cases.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final courtCase = cases[index];
          return CourtCaseCard(
            caseNumber: courtCase.caseNumber,
            year: courtCase.filingDate.year.toString(),
            courtCaseType: courtCase.caseType,
            status: courtCase.status,
            hasUnreadNotifications: courtCase.hasUnreadNotifications,
            isFollowed: courtCase.isFollowed,
            onFollowToggle: () {
              // This will be handled by the parent widget
            },
            onTap: () {
              // This will be handled by the parent widget
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_outlined, size: 64, color: AppColors.textLight),
          const SizedBox(height: 16),
          Text(
            emptyMessage,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            emptySubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
