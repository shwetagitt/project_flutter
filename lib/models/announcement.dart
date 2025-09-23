import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String id;
  final String title;
  final String body;
  final String clubId;
  final DateTime postedAt;

  Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.clubId,
    required this.postedAt,
  });

  factory Announcement.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Announcement(
      id: doc.id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      clubId: data['clubId'] ?? '',
      postedAt: (data['postedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'clubId': clubId,
      'postedAt': postedAt,
    };
  }
}
