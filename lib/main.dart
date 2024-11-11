// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/event_provider.dart';
import './screens/event_list_screen.dart';

void main() {
  runApp(EventPlannerApp());
}

class EventPlannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Event Planner',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: EventListScreen(),
      ),
    );
  }
}
