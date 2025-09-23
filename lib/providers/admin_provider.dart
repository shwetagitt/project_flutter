import 'package:flutter/material.dart';
import 'event_provider.dart';
import 'announcement_provider.dart';

class AdminProvider extends ChangeNotifier {
  EventProvider? _eventProvider;
  AnnouncementProvider? _announcementProvider;

  void updateProviders(EventProvider eventProvider, AnnouncementProvider announcementProvider) {
    _eventProvider = eventProvider;
    _announcementProvider = announcementProvider;
  }

  Future<void> postAnnouncement(String title, String body, String clubId) async {
    _announcementProvider?.addAnnouncement(title, body, clubId);
    notifyListeners();
  }

  Future<void> addEvent(String title, DateTime date, String clubId, String clubName) async {
    _eventProvider?.addEvent(title, date, clubId, clubName);
    notifyListeners();
  }

  Future<void> removeEvent(String eventId) async {
    _eventProvider?.removeEvent(eventId);
    notifyListeners();
  }

  Future<void> removeAnnouncement(String announcementId) async {
    _announcementProvider?.removeAnnouncement(announcementId);
    notifyListeners();
  }
}
