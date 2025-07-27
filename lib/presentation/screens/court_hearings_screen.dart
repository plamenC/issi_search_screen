import 'package:flutter/material.dart';
import '../../infrastructure/theme/app_colors.dart';

class CourtHearingsScreen extends StatelessWidget {
  const CourtHearingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              'Заседания',
              style: TextStyle(
                fontFamily: 'DejaVu Sans',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryIndigo,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Екранът за заседания ще бъде\nимплементиран скоро',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
