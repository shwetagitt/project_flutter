import 'package:flutter/material.dart';
import '../models/announcement.dart';

class AnnouncementProvider extends ChangeNotifier {
  final List<Announcement> _announcements = [
    Announcement(
      id: '1',
      title: 'Welcome to New Academic Year',
      body: 'We are excited to welcome all students to the new academic year. Join clubs and participate in exciting activities!',
      clubId: 'general',
      postedAt: DateTime.now().subtract(Duration(days: 2)),
    ),
    Announcement(
      id: '2',
      title: 'Club Registration Open',
      body: 'Club registration is now open for all students. Don\'t miss the opportunity to be part of amazing communities.',
      clubId: 'general',
      postedAt: DateTime.now().subtract(Duration(days: 1)),
    ),
  ];

  List<Announcement> get announcements => _announcements;

  void addAnnouncement(String title, String body, String clubId) {
    final newAnnouncement = Announcement(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      clubId: clubId,
      postedAt: DateTime.now(),
    );
    _announcements.insert(0, newAnnouncement); // Add to beginning
    notifyListeners();
  }

  void removeAnnouncement(String announcementId) {
    _announcements.removeWhere((announcement) => announcement.id == announcementId);
    notifyListeners();
  }

  Announcement getAnnouncementById(String id) {
    return _announcements.firstWhere((announcement) => announcement.id == id);
  }

  // For admin provider compatibility
  Future<void> postAnnouncement(String title, String body, String clubId) async {
    addAnnouncement(title, body, clubId);
  }
}
