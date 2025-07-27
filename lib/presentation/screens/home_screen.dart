import 'package:flutter/material.dart';
import '../../infrastructure/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home_outlined, size: 64, color: AppColors.primaryIndigo),
          SizedBox(height: 16),
          Text(
            'Начало',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Добре дошли в приложението'),
        ],
      ),
    );
  }
}
