import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/announcement_provider.dart';
import '../../widgets/announcement_tile.dart';
import '../../widgets/custom_app_bar.dart';
import '../../router.dart';

class AnnouncementsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final announcementProvider = Provider.of<AnnouncementProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Announcements',
        onProfileTap: () => Navigator.pushNamed(context, Routes.profile),
        onSettingsTap: () => Navigator.pushNamed(context, Routes.settings),
      ),
      body: announcementProvider.announcements.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8),
        itemCount: announcementProvider.announcements.length,
        itemBuilder: (context, index) {
          final announcement = announcementProvider.announcements[index];
          return AnnouncementTile(
            title: announcement.title,
            body: announcement.body,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.announcement_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No announcements yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Check back later for updates',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
