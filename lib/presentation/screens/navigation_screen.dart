import 'package:flutter/material.dart';
import '../../infrastructure/theme/app_colors.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_outlined,
            size: 64,
            color: AppColors.primaryIndigo,
          ),
          SizedBox(height: 16),
          Text(
            'Навигация',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Навигирайте с приложението'),
        ],
      ),
    );
  }
}
