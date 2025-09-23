import 'package:flutter/material.dart';

class MemberTile extends StatelessWidget {
  final String name;
  final String role;
  final String contact;

  const MemberTile({
    Key? key,
    required this.name,
    required this.role,
    required this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?'),
      ),
      title: Text(name, style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(role),
      trailing: Text(contact, style: TextStyle(color: Colors.grey[700])),
    );
  }
}
