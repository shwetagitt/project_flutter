import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../router.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Settings',
        onProfileTap: () => Navigator.pushNamed(context, Routes.profile),
        onSettingsTap: () {},
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSection(
            'Account',
            [
              _buildSettingsTile(
                'Profile',
                'Manage your profile information',
                Icons.person,
                    () => Navigator.pushNamed(context, Routes.profile),
              ),
              _buildSettingsTile(
                'Notifications',
                'Manage notification preferences',
                Icons.notifications,
                    () => _showComingSoonDialog(context, 'Notifications'),
              ),
            ],
          ),
          SizedBox(height: 24),
          _buildSection(
            'App',
            [
              _buildSettingsTile(
                'Theme',
                'Choose app theme',
                Icons.palette,
                    () => _showComingSoonDialog(context, 'Theme Settings'),
              ),
              _buildSettingsTile(
                'Language',
                'Change app language',
                Icons.language,
                    () => _showComingSoonDialog(context, 'Language Settings'),
              ),
              _buildSettingsTile(
                'About',
                'App version and information',
                Icons.info,
                    () => _showAboutDialog(context),
              ),
            ],
          ),
          SizedBox(height: 24),
          _buildSection(
            'Actions',
            [
              _buildSettingsTile(
                'Help & Support',
                'Get help and contact support',
                Icons.help,
                    () => _showComingSoonDialog(context, 'Help & Support'),
                textColor: Colors.blue,
              ),
              _buildSettingsTile(
                'Logout',
                'Sign out of your account',
                Icons.logout,
                    () => _showLogoutDialog(context, authProvider),
                textColor: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 12),
        Card(
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
      String title,
      String subtitle,
      IconData icon,
      VoidCallback onTap, {
        Color? textColor,
      }) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Coming Soon'),
        content: Text('$feature will be available in a future update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('About'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'College Club Management',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text('Version: 1.0.0'),
            Text('Built with Flutter'),
            SizedBox(height: 12),
            Text(
              'A comprehensive solution for managing college clubs, events, and member interactions.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await authProvider.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.login,
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
