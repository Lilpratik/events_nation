// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'event_manager_event_detail_screen.dart'; // Assuming you have this screen for event details

// class EventManagerEventListScreen extends StatefulWidget {
//   const EventManagerEventListScreen({super.key});

//   @override
//   _EventManagerEventListScreenState createState() =>
//       _EventManagerEventListScreenState();
// }

// class _EventManagerEventListScreenState
//     extends State<EventManagerEventListScreen> {
//   List events = []; // Stores the list of events

//   // Fetch events assigned to the Event Manager
//   Future<void> fetchEvents() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token'); // Get the token
//     final role = prefs.getString(
//         'user_role'); // Get the role (must be EventManager for this screen)

//     if (token == null || role != 'EventManager') {
//       // Redirect to login if no token or invalid role
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }

//     // API request to fetch events assigned to the Event Manager
//     final response = await http.get(
//       Uri.parse('http://192.168.0.108:5000/api/events/user/events'),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         events = json.decode(response.body); // Store events in state
//       });
//     } else {
//       print('Failed to fetch events');
//       // Handle failure (you could show a message to the user here)
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchEvents(); // Fetch events when the screen is initialized
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Event Manager - Event List')),
//       body: events.isEmpty
//           ? const Center(
//               child:
//                   CircularProgressIndicator()) // Show a loading indicator if no events
//           : ListView.builder(
//               itemCount: events.length,
//               itemBuilder: (context, index) {
//                 final event = events[index]; // Get each event
//                 return Card(
//                   margin: const EdgeInsets.symmetric(
//                       vertical: 8.0, horizontal: 16.0),
//                   child: ListTile(
//                     title: Text(event['event_name']), // Event Name
//                     subtitle: Text(event['description']), // Event Description
//                     onTap: () {
//                       // Navigate to event details screen
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               EventManagerEventDetailsScreen(event: event),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

// // new code

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'event_manager_event_detail_screen.dart';

class EventManagerEventListScreen extends StatefulWidget {
  const EventManagerEventListScreen({super.key});

  @override
  _EventManagerEventListScreenState createState() =>
      _EventManagerEventListScreenState();
}

class _EventManagerEventListScreenState
    extends State<EventManagerEventListScreen> {
  List events = [];
  bool isLoading = true;

  Future<void> fetchEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final role = prefs.getString('user_role');

    if (token == null || role != 'EventManager') {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final response = await http.get(
      Uri.parse('http://192.168.0.108:5000/api/events/user/events'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        events = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      print('Failed to fetch events');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EventManager - Event List'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : events.isEmpty
              ? const Center(
                  child: Text(
                    'No events found!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: Text(
                          event['event_name'],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(event['description'],
                              style: TextStyle(color: Colors.grey[700])),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: Colors.blueAccent),
                        onTap: () {
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
