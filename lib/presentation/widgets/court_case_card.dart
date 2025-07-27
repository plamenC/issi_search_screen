import 'package:flutter/material.dart';
import '../../infrastructure/theme/app_colors.dart';

class CourtCaseCard extends StatelessWidget {
  final String caseNumber;
  final String year;
  final String courtCaseType;
  final String? status;
  final bool hasUnreadNotifications;
  final bool isFollowed;
  final VoidCallback? onFollowToggle;
  final VoidCallback? onTap;

  const CourtCaseCard({
    super.key,
    required this.caseNumber,
    required this.year,
    required this.courtCaseType,
    this.status,
    this.hasUnreadNotifications = false,
    this.isFollowed = false,
    this.onFollowToggle,
    this.onTap,
  });

  Color _getStatusColor(String? status) {
    if (status == null) return AppColors.textDark;

    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.materialGreen;
      case 'pending':
        return AppColors.materialOrange;
      case 'closed':
        return AppColors.materialGrey;
      case 'appealed':
        return AppColors.materialPurple;
      default:
        return AppColors.materialBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        debugPrint('🎯 CourtCaseCard onTap triggered');
        onTap?.call();
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // TODO: This needs to be discussed with Jade.
            // Calculate if we need to stack vertically
            // Reserve space for icon (34px), padding (32px), folder icon (36px), and some margin
            final availableTextWidth = constraints.maxWidth - 102;
            final shouldStackVertically =
                availableTextWidth < 200; // Threshold for stacking

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Main content
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TODO: Discuss with Jade. The coloring looks stupid
                    // Folder icon with status-based color
                    Icon(
                      Icons.folder_outlined,
                      size: 24,
                      color: _getStatusColor(status),
                    ),
                    const SizedBox(width: 12),
                    // Text content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Case number and year - responsive layout
                          if (shouldStackVertically) ...[
                            // Stack vertically on small screens
                            Text(
                              'Дело № $caseNumber',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.425,
                                color: AppColors.textDark,
                              ),
                            ),
                            Text(
                              year,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.425,
                                color: AppColors.textDark,
                              ),
                            ),
                          ] else ...[
                            // Single line on larger screens
                            Text(
                              'Дело № $caseNumber / $year',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.425,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Text(
                            courtCaseType,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              height: 1.35,
                              letterSpacing: -0.075,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Reminder icon in top right corner
                Positioned(
                  top: -8,
                  right: -8,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        // Prevent tap from bubbling up to main card
                        // This stops the court details dialog from opening when tapping the notification icon
                        debugPrint(
                          '🔔 Notification icon tapped - preventing dialog',
                        );
                      },
                      onLongPress: onFollowToggle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            isFollowed
                                ? Icon(
                                    Icons.notifications,
                                    size: 18,
                                    color: AppColors.primaryLightGreen,
                                  )
                                : Icon(
                                    Icons.notifications_outlined,
                                    size: 18,
                                    color: AppColors.textLight,
                                  ),
                            if (hasUnreadNotifications && isFollowed)
                              Positioned(
                                right: 2,
                                top: 4,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLightGreen,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
