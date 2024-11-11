// lib/screens/event_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import 'add_event_screen.dart';
import 'event_detail_screen.dart';
import 'package:intl/intl.dart';

class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final List<String> _selectedEvents = []; // Track selected events for multi-select actions

  void _toggleSelection(String eventId) {
    setState(() {
      if (_selectedEvents.contains(eventId)) {
        _selectedEvents.remove(eventId);
      } else {
        _selectedEvents.add(eventId);
      }
    });
  }

  void _deleteSelectedEvents() {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    for (var eventId in _selectedEvents) {
      eventProvider.removeEvent(eventId);
    }
    setState(() {
      _selectedEvents.clear();
    });
  }

  void _completeSelectedEvents() {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    for (var eventId in _selectedEvents) {
      eventProvider.toggleEventCompletion(eventId);
    }
    setState(() {
      _selectedEvents.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final events = eventProvider.events;

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Planner'),
        backgroundColor: Color(0xFF8A9A5B), // Soft pastel green for a cozy feel
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEventScreen()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFF4E9D8), // Light pastel beige background
      floatingActionButton: _selectedEvents.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _deleteSelectedEvents,
              backgroundColor: Color(0xFFDB5461), // Soft red for delete button
              icon: Icon(Icons.delete),
              label: Text('Delete Selected'),
            )
          : null,
      body: Column(
        children: [
          if (_selectedEvents.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: _completeSelectedEvents,
                    icon: Icon(Icons.check),
                    label: Text('Complete Selected'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF77A3A1), // Soft teal for complete button
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadowColor: Colors.black38,
                      elevation: 4,
                    ),
                  ),
                  Text(
                    '${_selectedEvents.length} Selected',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (ctx, i) {
                final event = events[i];
                final isSelected = _selectedEvents.contains(event.id);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailScreen(eventId: event.id),
                      ),
                    );
                  },
                  onLongPress: () => _toggleSelection(event.id),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFFF5CAC3) : Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: isSelected ? Color(0xFFDB5461) : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Checkbox(
                        value: isSelected,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onChanged: (bool? isChecked) {
                          _toggleSelection(event.id);
                        },
                        activeColor: Color(0xFFDB5461),
                      ),
                      title: Text(
                        event.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.black87 : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        '${event.location} • ${DateFormat.yMMMd().format(event.date)}',
                        style: TextStyle(
                          color: isSelected ? Colors.black54 : Colors.black45,
                        ),
                      ),
                      trailing: Icon(
                        event.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: event.isCompleted ? Color(0xFF77A3A1) : Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
