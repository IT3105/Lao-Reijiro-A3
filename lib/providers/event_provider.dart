// lib/providers/event_provider.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/event.dart';

class EventProvider with ChangeNotifier {
  final List<Event> _events = [];
  final _uuid = Uuid();

  List<Event> get events => _events;
  List<Event> get upcomingEvents => _events.where((e) => e.date.isAfter(DateTime.now()) && !e.isCompleted).toList();
  List<Event> get completedEvents => _events.where((e) => e.isCompleted).toList();

  void addEvent(String title, DateTime date, String location, String description) {
    _events.add(Event(
      id: _uuid.v4(),
      title: title,
      date: date,
      location: location,
      description: description,
    ));
    notifyListeners();
  }

  void toggleEventCompletion(String id) {
    final event = _events.firstWhere((event) => event.id == id);
    event.isCompleted = !event.isCompleted;
    notifyListeners();
  }

  void removeEvent(String id) {
    _events.removeWhere((event) => event.id == id);
    notifyListeners();
  }
}
