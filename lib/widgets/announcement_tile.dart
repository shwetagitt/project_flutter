import 'package:flutter/material.dart';

class AnnouncementTile extends StatelessWidget {
  final String title;
  final String body;

  const AnnouncementTile({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(body, style: TextStyle(color: Colors.grey[800])),
          ],
        ),
      ),
    );
  }
}
