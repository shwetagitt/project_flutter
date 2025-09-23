import 'package:cloud_firestore/cloud_firestore.dart';

class Club {
  final String id;
  final String name;
  final String description;
  final String coordinatorId;
  final int membersCount;

  Club({
    required this.id,
    required this.name,
    required this.description,
    required this.coordinatorId,
    required this.membersCount,
  });

  factory Club.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Club(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      coordinatorId: data['coordinatorId'] ?? '',
      membersCount: data['membersCount'] ?? 0,
    );
  }

  factory Club.fromMap(Map<String, dynamic> data) {
    return Club(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      coordinatorId: data['coordinatorId'] ?? '',
      membersCount: data['membersCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'coordinatorId': coordinatorId,
      'membersCount': membersCount,
    };
  }
}
