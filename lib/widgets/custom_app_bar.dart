import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onProfileTap;
  final VoidCallback onSettingsTap;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.onProfileTap,
    required this.onSettingsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          icon: Icon(Icons.account_circle_outlined),
          tooltip: 'Profile',
          onPressed: onProfileTap,
        ),
        IconButton(
          icon: Icon(Icons.settings_outlined),
          tooltip: 'Settings',
          onPressed: onSettingsTap,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
