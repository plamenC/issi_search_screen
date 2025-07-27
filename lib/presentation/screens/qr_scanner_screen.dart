import 'package:flutter/material.dart';
import '../../infrastructure/theme/app_colors.dart';

class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.qr_code_scanner, size: 64, color: AppColors.primaryIndigo),
          SizedBox(height: 16),
          Text(
            'QR сканиране',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Сканирайте QR кодове'),
        ],
      ),
    );
  }
}
