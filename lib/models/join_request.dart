import 'package:cloud_firestore/cloud_firestore.dart';

class JoinRequest {
  final String id;
  final String userId;
  final String clubId;
  final String userEmail;
  final String clubName;
  final String status;
  final DateTime requestedAt;

  JoinRequest({
    required this.id,
    required this.userId,
    required this.clubId,
    required this.userEmail,
    required this.clubName,
    required this.status,
    required this.requestedAt,
  });

  factory JoinRequest.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return JoinRequest(
      id: doc.id,
      userId: data['userId'] ?? '',
      clubId: data['clubId'] ?? '',
      userEmail: data['userEmail'] ?? '',
      clubName: data['clubName'] ?? '',
      status: data['status'] ?? 'pending',
      requestedAt: (data['requestedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'clubId': clubId,
      'userEmail': userEmail,
      'clubName': clubName,
      'status': status,
      'requestedAt': Timestamp.fromDate(requestedAt),
    };
  }
}
