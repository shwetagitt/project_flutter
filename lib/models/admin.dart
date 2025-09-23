import 'package:cloud_firestore/cloud_firestore.dart';

class Admin {
  final String id;
  final String name;
  final String email;
  final String role;
  final List<String> permissions;
  final DateTime createdAt;

  Admin({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.permissions,
    required this.createdAt,
  });

  factory Admin.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Admin(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'Admin',
      permissions: List<String>.from(data['permissions'] ?? ['all']),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory Admin.fromMap(Map<String, dynamic> data) {
    return Admin(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'Admin',
      permissions: List<String>.from(data['permissions'] ?? ['all']),
      createdAt: data['createdAt'] ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'permissions': permissions,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  bool hasPermission(String permission) {
    return permissions.contains('all') || permissions.contains(permission);
  }
}
