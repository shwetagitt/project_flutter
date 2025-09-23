class User {
  final String id;
  final String name;
  final String email;
  final bool isAdmin;
  final List<String> clubs;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.isAdmin,
    required this.clubs,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      isAdmin: data['isAdmin'] ?? false,
      clubs: List<String>.from(data['clubs'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'isAdmin': isAdmin,
      'clubs': clubs,
    };
  }
}
