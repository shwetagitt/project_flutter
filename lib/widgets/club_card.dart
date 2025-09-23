import 'package:flutter/material.dart';

class ClubCard extends StatelessWidget {
  final String clubName;
  final String description;
  final VoidCallback onTap;
  final Widget? trailing; // <-- Add this

  const ClubCard({
    Key? key,
    required this.clubName,
    required this.description,
    required this.onTap,
    this.trailing, // <-- Add this
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          clubName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(description, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: trailing ?? Icon(Icons.arrow_forward_ios), // <-- Use passed trailing or default icon
        onTap: onTap,
      ),
    );
  }
}
