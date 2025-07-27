import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/theme/app_colors.dart';
import '../../application/providers/theme_provider.dart';

class CustomAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final bool unreadGlobalNotifications;

  const CustomAppBar({super.key, this.unreadGlobalNotifications = false});

  @override
  ConsumerState<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(88);
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  late bool hasUnreadGlobalNotifications;
  int notificationCount = 1;

  @override
  void initState() {
    super.initState();
    hasUnreadGlobalNotifications = widget.unreadGlobalNotifications;
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);

    // Debug print to show current theme
    debugPrint('AppBar build - Current theme: $themeMode');

    return SafeArea(
      child: Container(
        color: AppColors.backgroundLight,
        height: 88,
        padding: const EdgeInsets.only(
          left: 16,
          right:
              4, //compensate 16-12 (which is half of the IconButton width 48px)
          top: 4,
          bottom: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              'lib/infrastructure/assets/logo.svg',
              width: 61,
              fit: BoxFit.contain,
            ),
            Row(
              children: [
                // Theme toggle button
                IconButton(
                  style: IconButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () {
                    // Cycle through all three themes: light -> dark -> system -> light
                    debugPrint('Current theme before toggle: $themeMode');

                    switch (themeMode) {
                      case AppThemeMode.light:
                        ref
                            .read(themeProvider.notifier)
                            .changeTheme(AppThemeMode.dark);
                        break;
                      case AppThemeMode.dark:
                        ref
                            .read(themeProvider.notifier)
                            .changeTheme(AppThemeMode.system);
                        break;
                      case AppThemeMode.system:
                        ref
                            .read(themeProvider.notifier)
                            .changeTheme(AppThemeMode.light);
                        break;
                    }

                    debugPrint(
                      'Current theme after toggle: ${ref.read(themeProvider)}',
                    );

                    // Show system theme status
                    if (ref.read(themeProvider) == AppThemeMode.system) {
                      final isSystemDark =
                          MediaQuery.of(context).platformBrightness ==
                          Brightness.dark;
                      debugPrint(
                        'System theme detected: ${isSystemDark ? "DARK" : "LIGHT"}',
                      );
                    }
                  },
                  icon: Icon(
                    themeMode == AppThemeMode.dark
                        ? Icons.light_mode
                        : themeMode == AppThemeMode.system
                        ? Icons.brightness_auto
                        : Icons.dark_mode,
                    color: AppColors.textLight,
                    size: 24,
                  ),
                ),
                Stack(
                  children: [
                    IconButton(
                      style: IconButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: () {
                        //HACK: for tryouts only. delete later
                        setState(() {
                          if (hasUnreadGlobalNotifications) {
                            if (notificationCount < 13) {
                              notificationCount++;
                            } else {
                              // Reset to false when reaching 13
                              hasUnreadGlobalNotifications = false;
                              notificationCount = 1;
                            }
                          } else {
                            // Start showing notifications again from 1
                            hasUnreadGlobalNotifications = true;
                            notificationCount = 1;
                          }
                        });
                      },
                      icon: Icon(
                        Icons.notifications_outlined,
                        color: AppColors.textLight,
                        size: 24,
                      ),
                    ),
                    if (hasUnreadGlobalNotifications)
                      Positioned(
                        right: 8,
                        top: 10,
                        child: SizedBox(
                          width: 9,
                          height: 9,
                          child: Badge.count(
                            count: notificationCount,
                            backgroundColor: AppColors.primaryRed,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  child: IconButton(
                    style: IconButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () {
                      // Show theme settings - TODO: Implement navigation
                      debugPrint('Theme settings button pressed');
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: AppColors.textLight,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
