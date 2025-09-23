import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/club.dart';
import '../models/join_request.dart';
import '../models/member.dart';

class ClubProvider extends ChangeNotifier {
  final CollectionReference clubsRef = FirebaseFirestore.instance.collection('clubs');
  final CollectionReference joinRequestsRef = FirebaseFirestore.instance.collection('joinRequests');

  List<Club> _clubs = [];
  List<Club> get clubs => _clubs.isEmpty ? _getDummyClubs() : _clubs;

  List<JoinRequest> _joinRequests = [];
  List<JoinRequest> get joinRequests => _joinRequests;

  List<Member> _members = [];
  List<Member> get members => _members;

  ClubProvider() {
    _listenToClubs();
    _listenToJoinRequests();
    fetchMembersForClub('1'); // Load dummy members
  }

  // Dummy data for development
  List<Club> _getDummyClubs() {
    return [
      Club(
        id: '1',
        name: 'Computer Science Club',
        description: 'Explore the latest in technology, programming languages, AI, and software development. Join coding competitions and tech talks.',
        coordinatorId: 'admin1',
        membersCount: 45,
      ),
      Club(
        id: '2',
        name: 'Photography Club',
        description: 'Capture beautiful moments and learn advanced photography techniques. Weekly photo walks and editing workshops.',
        coordinatorId: 'admin2',
        membersCount: 32,
      ),
      Club(
        id: '3',
        name: 'Debate & Drama Society',
        description: 'Express yourself through powerful speeches and theatrical performances. Improve public speaking and acting skills.',
        coordinatorId: 'admin3',
        membersCount: 28,
      ),
      Club(
        id: '4',
        name: 'Music Club',
        description: 'Share your love for music through performances, jam sessions, and learning new instruments together.',
        coordinatorId: 'admin4',
        membersCount: 38,
      ),
    ];
  }

  // Add dummy member data
  void fetchMembersForClub(String clubId) {
    _members = [
      Member(
          id: '1',
          name: 'Alice Johnson',
          email: 'alice.johnson@college.edu',
          rollNumber: 'CS2021001',
          role: 'President',
          contact: '+1-555-0101'
      ),
      Member(
          id: '2',
          name: 'Bob Smith',
          email: 'bob.smith@college.edu',
          rollNumber: 'CS2021002',
          role: 'Vice President',
          contact: '+1-555-0102'
      ),
      Member(
          id: '3',
          name: 'Charlie Lee',
          email: 'charlie.lee@college.edu',
          rollNumber: 'CS2021003',
          role: 'Secretary',
          contact: '+1-555-0103'
      ),
      Member(
          id: '4',
          name: 'Diana Prince',
          email: 'diana.prince@college.edu',
          rollNumber: 'CS2021004',
          role: 'Treasurer',
          contact: '+1-555-0104'
      ),
      Member(
          id: '5',
          name: 'Ethan Hunt',
          email: 'ethan.hunt@college.edu',
          rollNumber: 'CS2021005',
          role: 'Member',
          contact: '+1-555-0105'
      ),
      Member(
          id: '6',
          name: 'Fiona Green',
          email: 'fiona.green@college.edu',
          rollNumber: 'CS2021006',
          role: 'Member',
          contact: '+1-555-0106'
      ),
    ];
    notifyListeners();
  }

  void _listenToClubs() {
    clubsRef.snapshots().listen((snapshot) {
      _clubs = snapshot.docs.map((doc) => Club.fromFirestore(doc)).toList();
      notifyListeners();
    });
  }

  void _listenToJoinRequests() {
    joinRequestsRef.snapshots().listen((snapshot) {
      _joinRequests = snapshot.docs.map((doc) => JoinRequest.fromFirestore(doc)).toList();
      notifyListeners();
    });
  }

  Future<void> requestToJoin(String clubId, String userId, String userEmail, String clubName) async {
    try {
      // Check if user already requested
      final existingRequest = _joinRequests.where(
            (request) => request.clubId == clubId && request.userId == userId,
      ).toList();

      if (existingRequest.isNotEmpty) {
        throw Exception('You have already requested to join this club');
      }

      await joinRequestsRef.add({
        'userId': userId,
        'clubId': clubId,
        'userEmail': userEmail,
        'clubName': clubName,
        'status': 'pending',
        'requestedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Join request sent successfully');
    } catch (e) {
      print('❌ Error sending join request: $e');
      throw e;
    }
  }

  // Fix method names for join requests screen
  Future<void> approveJoinRequest(String requestId) async {
    try {
      await joinRequestsRef.doc(requestId).update({'status': 'approved'});
      print('✅ Join request approved');
    } catch (e) {
      print('❌ Error approving join request: $e');
      throw e;
    }
  }

  Future<void> rejectJoinRequest(String requestId) async {
    try {
      await joinRequestsRef.doc(requestId).update({'status': 'rejected'});
      print('✅ Join request rejected');
    } catch (e) {
      print('❌ Error rejecting join request: $e');
      throw e;
    }
  }

  // Add these aliases for the join requests screen
  Future<void> acceptRequest(String requestId) => approveJoinRequest(requestId);
  Future<void> rejectRequest(String requestId) => rejectJoinRequest(requestId);

  List<Member> getClubMembers(String clubId) {
    // For demo, return all members regardless of clubId
    return _members;
  }

  Club? getClubById(String clubId) {
    try {
      return clubs.firstWhere((club) => club.id == clubId);
    } catch (e) {
      return null;
    }
  }
}
