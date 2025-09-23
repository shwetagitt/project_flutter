import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventItem extends StatelessWidget {
  final String title;
  final String clubName;
  final DateTime date;
  final VoidCallback onTap;

  const EventItem({
    Key? key,
    required this.title,
    required this.clubName,
    required this.date,
    required this.onTap,
  }) : super(key: key);

  String get formattedDate => DateFormat('dd MMM yyyy, hh:mm a').format(date);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$clubName · $formattedDate'),
        trailing: Icon(Icons.event),
        onTap: onTap,
      ),
    );
  }
}
