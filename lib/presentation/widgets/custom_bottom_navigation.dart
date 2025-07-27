import 'package:flutter/material.dart';
import '../../infrastructure/theme/app_colors.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;

              // Determine layout strategy based on screen width
              final isVerySmall = screenWidth < 320; // Very small phones
              final isSmall = screenWidth < 380; // Small phones
              final isMedium = screenWidth < 450; // Medium phones

              // Adaptive strategies:
              final showAllLabels =
                  !isVerySmall; // Show all labels except on very small screens
              final showSelectedLabelOnly =
                  isVerySmall; // On very small screens, show only selected label
              final useCompactSpacing =
                  isSmall; // Tighter spacing on small screens
              final fontSize = isSmall
                  ? 10.0
                  : 12.0; // Smaller font on small screens
              final iconSize = isVerySmall ? 20.0 : (isSmall ? 22.0 : 24.0);
              final selectedIconSize = isVerySmall
                  ? 24.0
                  : (isSmall ? 26.0 : 28.0);
              final verticalPadding = useCompactSpacing ? 12.0 : 16.0;

              return Container(
                constraints: BoxConstraints(
                  minHeight: showAllLabels || showSelectedLabelOnly ? 40 : 30,
                ),
                color: AppColors.backgroundLight,
                child: _buildResponsiveLayout(
                  isVerySmall: isVerySmall,
                  isSmall: isSmall,
                  isMedium: isMedium,
                  showAllLabels: showAllLabels,
                  showSelectedLabelOnly: showSelectedLabelOnly,
                  fontSize: fontSize,
                  iconSize: iconSize,
                  selectedIconSize: selectedIconSize,
                  verticalPadding: verticalPadding,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveLayout({
    required bool isVerySmall,
    required bool isSmall,
    required bool isMedium,
    required bool showAllLabels,
    required bool showSelectedLabelOnly,
    required double fontSize,
    required double iconSize,
    required double selectedIconSize,
    required double verticalPadding,
  }) {
    if (isVerySmall) {
      // For very small screens: Single row with minimal spacing, only selected label shown
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: verticalPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCustomNavigationItem(
              0,
              Icons.home_outlined,
              'Начало',
              showAllLabels: showAllLabels,
              showSelectedLabelOnly: showSelectedLabelOnly,
              fontSize: fontSize,
              iconSize: iconSize,
              selectedIconSize: selectedIconSize,
            ),
            _buildCustomNavigationItem(
              1,
              Icons.gavel_outlined,
              'Дела',
              showAllLabels: showAllLabels,
              showSelectedLabelOnly: showSelectedLabelOnly,
              fontSize: fontSize,
              iconSize: iconSize,
              selectedIconSize: selectedIconSize,
            ),
            _buildCustomNavigationItem(
              2,
              Icons.calendar_today_outlined,
              'Заседания',
              showAllLabels: showAllLabels,
              showSelectedLabelOnly: showSelectedLabelOnly,
              fontSize: fontSize,
              iconSize: iconSize,
              selectedIconSize: selectedIconSize,
            ),
            _buildCustomNavigationItem(
              3,
              Icons.directions_outlined,
              'Навигация',
              showAllLabels: showAllLabels,
              showSelectedLabelOnly: showSelectedLabelOnly,
              fontSize: fontSize,
              iconSize: iconSize,
              selectedIconSize: selectedIconSize,
            ),
            _buildCustomNavigationItem(
              4,
              Icons.qr_code_scanner,
              'QR скенер',
              showAllLabels: showAllLabels,
              showSelectedLabelOnly: showSelectedLabelOnly,
              fontSize: fontSize,
              iconSize: iconSize,
              selectedIconSize: selectedIconSize,
            ),
          ],
        ),
      );
    } else {
      // Original 3-section layout for larger screens
      return Row(
        children: [
          // Left side items
          Expanded(
            child: Row(
              mainAxisAlignment: isSmall
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.spaceEvenly,
              children: [
                _buildCustomNavigationItem(
                  0,
                  Icons.home_outlined,
                  'Начало',
                  showAllLabels: showAllLabels,
                  showSelectedLabelOnly: showSelectedLabelOnly,
                  fontSize: fontSize,
                  iconSize: iconSize,
                  selectedIconSize: selectedIconSize,
                ),
                _buildCustomNavigationItem(
                  1,
                  Icons.gavel_outlined,
                  'Дела',
                  showAllLabels: showAllLabels,
                  showSelectedLabelOnly: showSelectedLabelOnly,
                  fontSize: fontSize,
                  iconSize: iconSize,
                  selectedIconSize: selectedIconSize,
                ),
              ],
            ),
          ),
          // Center item
          _buildCustomNavigationItem(
            2,
            Icons.calendar_today_outlined,
            'Заседания',
            showAllLabels: showAllLabels,
            showSelectedLabelOnly: showSelectedLabelOnly,
            fontSize: fontSize,
            iconSize: iconSize,
            selectedIconSize: selectedIconSize,
          ),
          // Right side items
          Expanded(
            child: Row(
              mainAxisAlignment: isSmall
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.spaceEvenly,
              children: [
                _buildCustomNavigationItem(
                  3,
                  Icons.directions_outlined,
                  'Навигация',
                  showAllLabels: showAllLabels,
                  showSelectedLabelOnly: showSelectedLabelOnly,
                  fontSize: fontSize,
                  iconSize: iconSize,
                  selectedIconSize: selectedIconSize,
                ),
                _buildCustomNavigationItem(
                  4,
                  Icons.qr_code_scanner,
                  'QR скенер',
                  showAllLabels: showAllLabels,
                  showSelectedLabelOnly: showSelectedLabelOnly,
                  fontSize: fontSize,
                  iconSize: iconSize,
                  selectedIconSize: selectedIconSize,
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _buildCustomNavigationItem(
    int index,
    IconData icon,
    String label, {
    required bool showAllLabels,
    required bool showSelectedLabelOnly,
    required double fontSize,
    required double iconSize,
    required double selectedIconSize,
  }) {
    final isSelected = selectedIndex == index;
    final shouldShowLabel =
        showAllLabels || (showSelectedLabelOnly && isSelected);

    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 48,
          minWidth: 48, //TODO: check with Jade
        ),
        child: GestureDetector(
          onTap: () => onItemTapped(index),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: isSelected ? selectedIconSize : iconSize,
                color: isSelected
                    ? AppColors.primaryIndigo
                    : AppColors.overlayIndigo,
              ),
              if (shouldShowLabel) ...[
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'DejaVu Sans',
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    fontSize: fontSize,
                    height: 1.2, // Tighter line height for better spacing
                    letterSpacing: 0,
                    color: isSelected
                        ? AppColors.primaryIndigo
                        : AppColors.overlayIndigo,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis, // Handle text overflow gracefully
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
