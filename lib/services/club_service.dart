import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/member.dart';

class ClubService {
  final CollectionReference clubsRef = FirebaseFirestore.instance.collection('clubs');
  final CollectionReference membersRef = FirebaseFirestore.instance.collection('members');

  // Fetch members for a given club
  Future<List<Member>> fetchMembers(String clubId) async {
    try {
      final snapshot = await membersRef.where('clubId', isEqualTo: clubId).get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Use fromMap instead of fromFirestore
        return Member.fromMap({
          'id': doc.id,
          'name': data['name'],
          'email': data['email'],
          'rollNumber': data['rollNumber'],
          'role': data['role'],
          'contact': data['contact'],
        });
      }).toList();
    } catch (e) {
      throw Exception('Error fetching members: $e');
    }
  }

  // Add join request
  Future<void> sendJoinRequest(String clubId, String userId, String email, String clubName) async {
    await FirebaseFirestore.instance.collection('joinRequests').add({
      'clubId': clubId,
      'userId': userId,
      'userEmail': email,
      'clubName': clubName,
      'status': 'pending',
      'requestedAt': FieldValue.serverTimestamp(),
    });
  }
}
