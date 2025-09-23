import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../models/admin.dart';
import '../router.dart';

class AuthProvider extends ChangeNotifier {
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  Admin? _currentAdmin;

  User? get currentUser => _currentUser;
  Admin? get currentAdmin => _currentAdmin;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin == true;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(fb_auth.User? firebaseUser) async {
    if (firebaseUser == null) {
      _currentUser = null;
      _currentAdmin = null;
      notifyListeners();
    } else {
      await _loadUserData(firebaseUser);
    }
  }

  Future<void> _loadUserData(fb_auth.User firebaseUser) async {
    try {
      // Check if admin email
      bool isAdminEmail = firebaseUser.email == 'admin@college.edu';

      final docRef = _firestore.collection('users').doc(firebaseUser.uid);
      final doc = await docRef.get();

      if (!doc.exists) {
        // Create new user document
        await docRef.set({
          'name': isAdminEmail ? 'Administrator' : 'Student User',
          'email': firebaseUser.email,
          'isAdmin': isAdminEmail,
          'clubs': [],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      final userData = (await docRef.get()).data()!;

      _currentUser = User(
        id: firebaseUser.uid,
        name: userData['name'] ?? (isAdminEmail ? 'Administrator' : 'Student User'),
        email: firebaseUser.email ?? '',
        isAdmin: userData['isAdmin'] ?? isAdminEmail,
        clubs: List<String>.from(userData['clubs'] ?? []),
      );

      // Load admin data if user is admin
      if (_currentUser!.isAdmin) {
        await _loadAdminData(firebaseUser);
      }

      print('✅ User loaded: ${_currentUser?.email}, isAdmin: ${_currentUser?.isAdmin}');
      notifyListeners();
    } catch (e) {
      print('❌ Error loading user data: $e');
      // Create basic user even if there's an error
      _currentUser = User(
        id: firebaseUser.uid,
        name: firebaseUser.email == 'admin@college.edu' ? 'Administrator' : 'Student User',
        email: firebaseUser.email ?? '',
        isAdmin: firebaseUser.email == 'admin@college.edu',
        clubs: [],
      );
      notifyListeners();
    }
  }

  Future<void> _loadAdminData(fb_auth.User firebaseUser) async {
    try {
      final adminDocRef = _firestore.collection('admins').doc(firebaseUser.uid);
      final adminDoc = await adminDocRef.get();

      if (!adminDoc.exists) {
        // Create admin document
        await adminDocRef.set({
          'name': 'Administrator',
          'email': firebaseUser.email,
          'role': 'Super Admin',
          'permissions': ['all'],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      final adminData = (await adminDocRef.get()).data()!;
      _currentAdmin = Admin(
        id: firebaseUser.uid,
        name: adminData['name'] ?? 'Administrator',
        email: firebaseUser.email ?? '',
        role: adminData['role'] ?? 'Super Admin',
        permissions: List<String>.from(adminData['permissions'] ?? ['all']),
        createdAt: (adminData['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    } catch (e) {
      print('❌ Error loading admin data: $e');
    }
  }

  Future<String> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Wait for user data to load
      await Future.delayed(Duration(milliseconds: 1500));

      print('🚀 Login completed. User: ${_currentUser?.email}, isAdmin: ${_currentUser?.isAdmin}');

      // Return appropriate route
      if (_currentUser?.isAdmin == true) {
        print('🛡️ Redirecting to admin dashboard');
        return Routes.adminDashboard;
      } else {
        print('🎓 Redirecting to student dashboard');
        return Routes.dashboard;
      }
    } on fb_auth.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login failed');
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      await _firestore.collection('users').doc(cred.user!.uid).set({
        'name': name,
        'email': email,
        'isAdmin': false, // New registrations are students
        'clubs': [],
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on fb_auth.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Registration failed');
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      _currentUser = null;
      _currentAdmin = null;
      notifyListeners();
    } catch (e) {
      print('❌ Logout error: $e');
    }
  }
}
