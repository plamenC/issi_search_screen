import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool unreadNotifications;

  const CustomAppBar({super.key, this.unreadNotifications = false});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: const Color(0xFFFBFBFE),
        height: 88,
        padding: const EdgeInsets.only(
          left: 16,
          right:
              4, //compensate 16-12 (which is half of the IconButton width 48px)
          //TODO: Ask Jade
          top: 4,
          bottom: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              'lib/assets/logo.svg',
              width: 61,
              fit: BoxFit.contain,
            ),
            Row(
              children: [
                SizedBox(
                  child: Stack(
                    children: [
                      IconButton(
                        style: IconButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () {},
                        icon: Icon(
                          Icons.notifications_outlined,
                          color: Color(0xFF9394A0),
                          size: 24,
                        ),
                      ),
                      // Red dot for unread notifications
                      if (unreadNotifications)
                        Positioned(
                          right: 12,
                          top: 14,
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
                SizedBox(
                  child: IconButton(
                    style: IconButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_vert,
                      color: Color(0xFF9394A0),
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

  @override
  Size get preferredSize => const Size.fromHeight(88);
}
