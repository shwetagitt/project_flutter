import 'package:flutter/material.dart';
import '../models/event.dart';

class EventProvider extends ChangeNotifier {
  final List<Event> _events = [
    Event(
      id: '1',
      title: 'Tech Talk: AI in Future',
      date: DateTime.now().add(Duration(days: 3)),
      clubId: '1',
      clubName: 'Computer Science Club',
    ),
    Event(
      id: '2',
      title: 'Photography Workshop',
      date: DateTime.now().add(Duration(days: 7)),
      clubId: '2',
      clubName: 'Photography Club',
    ),
    Event(
      id: '3',
      title: 'Debate Competition',
      date: DateTime.now().add(Duration(days: 10)),
      clubId: '3',
      clubName: 'Debate & Drama Society',
    ),
  ];

  List<Event> get events => _events;

  void addEvent(String title, DateTime date, String clubId, String clubName) {
    final newEvent = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      date: date,
      clubId: clubId,
      clubName: clubName,
    );
    _events.add(newEvent);
    notifyListeners();
  }

  void removeEvent(String eventId) {
    _events.removeWhere((event) => event.id == eventId);
    notifyListeners();
  }

  Event getEventById(String id) {
    return _events.firstWhere((event) => event.id == id);
  }
}
