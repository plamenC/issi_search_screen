import 'package:flutter/material.dart';

class CourtCaseCard extends StatelessWidget {
  final String caseNumber;
  final String year;
  final bool hasUnreadNotifications;
  final bool isFollowed;

  const CourtCaseCard({
    super.key,
    required this.caseNumber,
    required this.year,
    this.hasUnreadNotifications = false,
    this.isFollowed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFEEEFF6),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Stack(
        children: [
          // Main content
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Folder icon
              Icon(
                Icons.folder_outlined,
                size: 24,
                color: const Color(0xFF1B1C28),
              ),
              const SizedBox(width: 12),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Дело № $caseNumber',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.425, // -2.5% of 17px
                        color: Color(0xFF1B1C28),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      year,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                        letterSpacing: -0.075, // -0.5% of 15px
                        color: Color(0xFF1B1C28),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Notification icon in top right corner
          Positioned(
            top: 0,
            right: 0,
            child: Stack(
              children: [
                isFollowed
                    ? Icon(
                        Icons.notifications,
                        size: 24,
                        color: const Color(0xFF89B82D),
                      )
                    : Icon(
                        Icons.notifications_outlined,
                        size: 24,
                        color: const Color(0xFF9394A0),
                      ),
                if (hasUnreadNotifications)
                  Positioned(
                    right: 2,
                    top: 4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
