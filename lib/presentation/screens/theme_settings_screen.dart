// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../infrastructure/theme/app_colors.dart';
// import '../../infrastructure/theme/app_theme.dart';

// class ThemeSettingsScreen extends StatelessWidget {
//   const ThemeSettingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeController = Get.find<ThemeController>();

//     return Scaffold(
//       backgroundColor: AppColors.backgroundLight,
//       appBar: AppBar(
//         title: Text(
//           'Настройки на темата',
//           style: TextStyle(
//             fontFamily: 'DejaVu Sans',
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//             color: AppColors.primaryIndigo,
//           ),
//         ),
//         backgroundColor: AppColors.backgroundLight,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Изберете тема',
//               style: TextStyle(
//                 fontFamily: 'DejaVu Sans',
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Obx(
//               () => Column(
//                 children: [
//                   _buildThemeOption(
//                     context,
//                     title: 'Светла тема',
//                     subtitle: 'Използва светли цветове',
//                     icon: Icons.light_mode,
//                     isSelected:
//                         themeController.currentThemeMode == AppThemeMode.light,
//                     onTap: () =>
//                         themeController.changeTheme(AppThemeMode.light),
//                   ),
//                   const SizedBox(height: 12),
//                   _buildThemeOption(
//                     context,
//                     title: 'Тъмна тема',
//                     subtitle: 'Използва тъмни цветове',
//                     icon: Icons.dark_mode,
//                     isSelected:
//                         themeController.currentThemeMode == AppThemeMode.dark,
//                     onTap: () => themeController.changeTheme(AppThemeMode.dark),
//                   ),
//                   const SizedBox(height: 12),
//                   _buildThemeOption(
//                     context,
//                     title: 'Системна тема',
//                     subtitle: 'Следва настройките на устройството',
//                     icon: Icons.settings_system_daydream,
//                     isSelected:
//                         themeController.currentThemeMode == AppThemeMode.system,
//                     onTap: () =>
//                         themeController.changeTheme(AppThemeMode.system),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 32),
//             Text(
//               'Предварителен преглед',
//               style: TextStyle(
//                 fontFamily: 'DejaVu Sans',
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//             const SizedBox(height: 16),
//             _buildPreviewCard(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildThemeOption(
//     BuildContext context, {
//     required String title,
//     required String subtitle,
//     required IconData icon,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(8),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? AppColors.primaryIndigo.withValues(alpha: 0.1)
//               : AppColors.backgroundCard,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//             color: isSelected ? AppColors.primaryIndigo : AppColors.borderLight,
//             width: isSelected ? 2 : 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               color: isSelected
//                   ? AppColors.primaryIndigo
//                   : AppColors.textSecondary,
//               size: 24,
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontFamily: 'DejaVu Sans',
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     subtitle,
//                     style: TextStyle(
//                       fontFamily: 'Roboto',
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       color: AppColors.textSecondary,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (isSelected)
//               Icon(
//                 Icons.check_circle,
//                 color: AppColors.primaryIndigo,
//                 size: 24,
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPreviewCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.backgroundCard,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: AppColors.borderLight),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: AppColors.primaryIndigo,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(Icons.gavel, color: AppColors.textWhite, size: 20),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Дело № 123/2024',
//                       style: TextStyle(
//                         fontFamily: 'DejaVu Sans',
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.textPrimary,
//                       ),
//                     ),
//                     Text(
//                       'Гражданско дело',
//                       style: TextStyle(
//                         fontFamily: 'Roboto',
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         color: AppColors.textSecondary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(Icons.favorite, color: AppColors.primaryRed, size: 20),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: AppColors.materialGreen.withValues(alpha: 0.1),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: AppColors.materialGreen.withValues(alpha: 0.3),
//               ),
//             ),
//             child: Text(
//               'АКТИВНО',
//               style: TextStyle(
//                 color: AppColors.materialGreen,
//                 fontSize: 11,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
