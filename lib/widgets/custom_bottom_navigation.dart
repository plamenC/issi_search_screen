import 'package:flutter/material.dart';

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
          Container(
            constraints: const BoxConstraints(minHeight: 40),
            color: const Color(0xFFFBFBFE),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCustomNavigationItem(0, Icons.home_outlined, 'Начало'),
                _buildCustomNavigationItem(1, Icons.search, 'Търсене'),
                _buildCustomNavigationItem(
                  2,
                  Icons.folder_copy_outlined,
                  'Моите дела',
                ),
                _buildCustomNavigationItem(
                  3,
                  Icons.directions_outlined,
                  'Навигация',
                ),
                _buildCustomNavigationItem(
                  4,
                  Icons.qr_code_scanner,
                  'QR скенер',
                ),
              ],
            ),
          ),
          // Container(height: 32, color: Colors.red.shade200),
        ],
      ),
    );
  }

  Widget _buildCustomNavigationItem(int index, IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: GestureDetector(
        onTap: () => onItemTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: selectedIndex == index
                  ? 26
                  : 24, //selected icons to appear bolder.
              // TODO: Ask Jade if she likes it.
              color: selectedIndex == index
                  ? const Color(0xFF1A237E)
                  : const Color(0x7314162E),
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Verdana',
                fontWeight: selectedIndex == index
                    ? FontWeight.w700
                    : FontWeight.w400,
                fontSize: 12,
                height: 1.35,
                letterSpacing: 0,
                color: selectedIndex == index
                    ? const Color(0xFF1A237E)
                    : const Color(0x7314162E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
