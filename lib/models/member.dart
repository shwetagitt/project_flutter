class Member {
  final String id;
  final String name;
  final String email;
  final String rollNumber;
  final String role;
  final String contact;

  Member({
    required this.id,
    required this.name,
    required this.email,
    required this.rollNumber,
    required this.role,
    required this.contact,
  });

  factory Member.fromMap(Map<String, dynamic> data) {
    return Member(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      rollNumber: data['rollNumber'] ?? '',
      role: data['role'] ?? 'Member',
      contact: data['contact'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'rollNumber': rollNumber,
      'role': role,
      'contact': contact,
    };
  }
}
