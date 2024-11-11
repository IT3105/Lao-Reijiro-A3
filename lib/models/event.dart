// lib/models/event.dart
class Event {
  String id;
  String title;
  DateTime date;
  String location;
  String description;
  bool isCompleted;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.description,
    this.isCompleted = false,
  });
}
