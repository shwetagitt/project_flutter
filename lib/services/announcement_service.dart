import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/announcement.dart';

class AnnouncementService {
  final CollectionReference announcementsCollection =
  FirebaseFirestore.instance.collection('announcements');

  Future<List<Announcement>> getAnnouncements() async {
    QuerySnapshot snapshot = await announcementsCollection.orderBy('postedAt', descending: true).get();
    return snapshot.docs.map((doc) => Announcement.fromFirestore(doc)).toList();
  }

  Future<void> postAnnouncement(String title, String body) async {
    await announcementsCollection.add({
      'title': title,
      'body': body,
      'postedAt': FieldValue.serverTimestamp(),
    });
  }
}
