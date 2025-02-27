import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'event_manager_event_detail_screen.dart'; // Assuming you have this screen for event details

class EventManagerEventListScreen extends StatefulWidget {
  const EventManagerEventListScreen({super.key});

  @override
  _EventManagerEventListScreenState createState() =>
      _EventManagerEventListScreenState();
}

class _EventManagerEventListScreenState
    extends State<EventManagerEventListScreen> {
  List events = []; // Stores the list of events

  // Fetch events assigned to the Event Manager
  Future<void> fetchEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token'); // Get the token
    final role = prefs.getString(
        'user_role'); // Get the role (must be EventManager for this screen)

    if (token == null || role != 'EventManager') {
      // Redirect to login if no token or invalid role
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    // API request to fetch events assigned to the Event Manager
    final response = await http.get(
      Uri.parse('http://192.168.0.106:5000/api/events/user/events'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        events = json.decode(response.body); // Store events in state
      });
    } else {
      print('Failed to fetch events');
      // Handle failure (you could show a message to the user here)
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEvents(); // Fetch events when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Manager - Event List')),
      body: events.isEmpty
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show a loading indicator if no events
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index]; // Get each event
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(event['event_name']), // Event Name
                    subtitle: Text(event['description']), // Event Description
                    onTap: () {
                      // Navigate to event details screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EventManagerEventDetailsScreen(event: event),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
