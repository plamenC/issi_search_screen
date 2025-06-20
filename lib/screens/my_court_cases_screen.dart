import 'package:flutter/material.dart';

class MyCourtCasesScreen extends StatelessWidget {
  const MyCourtCasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_copy_outlined, size: 64, color: Color(0xFF1A237E)),
          SizedBox(height: 16),
          Text(
            'Моите дела',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Управлявайте вашите дела'),
        ],
      ),
    );
  }
}
