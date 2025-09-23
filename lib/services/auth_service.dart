// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<User?> signInWithEmail(String email, String password) async {
//     try {
//       UserCredential result = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return result.user;
//     } catch (e) {
//       print('Sign in error: $e');
//       return null;
//     }
//   }
//
//   Future<User?> registerWithEmail(String email, String password, String name) async {
//     try {
//       UserCredential result = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       if (result.user != null) {
//         await _firestore.collection('users').doc(result.user!.uid).set({
//           'name': name,
//           'email': email,
//           'isAdmin': false,
//         });
//       }
//
//       return result.user;
//     } catch (e) {
//       print('Registration error: $e');
//       return null;
//     }
//   }
//
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(fb_auth.User? firebaseUser) async {
    if (firebaseUser == null) {
      _currentUser = null;
      notifyListeners();
    } else {
      await _loadUserData(firebaseUser);
    }
  }

  Future<void> _loadUserData(fb_auth.User firebaseUser) async {
    try {
      // Special handling for demo accounts
      bool isAdmin = false;
      String userName = firebaseUser.email ?? 'User';

      if (firebaseUser.email == 'admin@college.edu') {
        isAdmin = true;
        userName = 'Administrator';
      } else if (firebaseUser.email == 'student@college.edu') {
        isAdmin = false;
        userName = 'Student User';
      }

      // Try to get from Firestore
      try {
        final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
        if (doc.exists) {
          final data = doc.data()!;
          isAdmin = data['isAdmin'] ?? isAdmin;
          userName = data['name'] ?? userName;
        } else {
          // Create user document
          await _firestore.collection('users').doc(firebaseUser.uid).set({
            'name': userName,
            'email': firebaseUser.email,
            'isAdmin': isAdmin,
            'clubs': [],
          });
        }
      } catch (e) {
        print('Firestore error, using default values: $e');
      }

      _currentUser = User(
        id: firebaseUser.uid,
        name: userName,
        email: firebaseUser.email ?? '',
        isAdmin: isAdmin,
        clubs: [],
      );

      print('✅ User loaded: ${_currentUser?.email}, isAdmin: ${_currentUser?.isAdmin}');
      notifyListeners();
    } catch (e) {
      print('❌ Error loading user data: $e');
    }
  }

  Future<String> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Wait for user data to load
      await Future.delayed(Duration(milliseconds: 1500));

      print('🚀 Login completed. User: ${_currentUser?.email}, isAdmin: ${_currentUser?.isAdmin}');

      // Return route based on user type
      if (_currentUser?.isAdmin == true) {
        print('🛡️ Redirecting to admin dashboard');
        return '/admin-dashboard';
      } else {
        print('🎓 Redirecting to student dashboard');
        return '/dashboard';
      }
    } on fb_auth.FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'name': name,
        'email': email,
        'isAdmin': false, // New users are not admin by default
        'clubs': [],
      });
    } on fb_auth.FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
