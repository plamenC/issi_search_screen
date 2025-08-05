import 'package:flutter/material.dart';
import '../../infrastructure/theme/app_colors.dart';

class LoadingState extends StatelessWidget {
  final String message;
  final double size;

  const LoadingState({
    super.key,
    this.message = 'Loading...',
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primaryIndigo,
              ),
            ),
          ),
          if (message.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}
