import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class EventService {
  final CollectionReference eventsCollection = FirebaseFirestore.instance.collection('events');

  Future<List<Event>> getAllEvents(String filter) async {
    QuerySnapshot snapshot;
    var now = DateTime.now();

    if (filter == 'Upcoming') {
      snapshot = await eventsCollection.where('date', isGreaterThanOrEqualTo: now).get();
    } else {
      snapshot = await eventsCollection.where('date', isLessThan: now).get();
    }
    return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
  }

  Future<List<Event>> getEventsByClub(String clubId, String filter) async {
    QuerySnapshot snapshot;
    var now = DateTime.now();

    if (filter == 'Upcoming') {
      snapshot = await eventsCollection
          .where('clubId', isEqualTo: clubId)
          .where('date', isGreaterThanOrEqualTo: now)
          .get();
    } else {
      snapshot = await eventsCollection
          .where('clubId', isEqualTo: clubId)
          .where('date', isLessThan: now)
          .get();
    }
    return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
  }

  Future<Event> getEventById(String id) async {
    DocumentSnapshot doc = await eventsCollection.doc(id).get();
    return Event.fromFirestore(doc);
  }

  Future<void> addEvent(Event event) async {
    await eventsCollection.add(event.toMap());
  }

  Future<void> updateEvent(Event event) async {
    await eventsCollection.doc(event.id).update(event.toMap());
  }

  Future<void> deleteEvent(String id) async {
    await eventsCollection.doc(id).delete();
  }
}
