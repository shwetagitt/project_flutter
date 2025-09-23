import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final DateTime date;
  final String clubId;
  final String clubName;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.clubId,
    required this.clubName,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      clubId: data['clubId'] ?? '',
      clubName: data['clubName'] ?? '',
    );
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      date: map['date'] ?? DateTime.now(),
      clubId: map['clubId'] ?? '',
      clubName: map['clubName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
      'clubId': clubId,
      'clubName': clubName,
    };
  }
}
