// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:frontend/views/supervisor_event_detail_screen.dart';
// import 'package:frontend/views/create_event_screen.dart'; // Import the CreateEventScreen

// class SupervisorEventListScreen extends StatefulWidget {
//   const SupervisorEventListScreen({super.key});

//   @override
//   _SupervisorEventListScreenState createState() =>
//       _SupervisorEventListScreenState();
// }

// class _SupervisorEventListScreenState extends State<SupervisorEventListScreen> {
//   List events = [];

//   Future<void> fetchEvents() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');
//     final role = prefs.getString('user_role');

//     if (token == null || role == null) {
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }

//     final response = await http.get(
//       Uri.parse('http://192.168.0.108:5000/api/events'),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         events = json.decode(response.body);
//       });
//     } else {
//       print('Failed to fetch events');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchEvents();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Supervisor - Event List'),
//       ),
//       body: ListView.builder(
//         itemCount: events.length,
//         itemBuilder: (context, index) {
//           final event = events[index];
//           return Card(
//             margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//             child: ListTile(
//               title: Text(event['event_name']),
//               subtitle: Text(event['description']),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         SupervisorEventDetailsScreen(event: event),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const CreateEventScreen()),
//           );
//         },
//         child: const Icon(Icons.add),
//         tooltip: 'Create Event',
//       ),
//     );
//   }
// }

// new code

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/views/supervisor_event_detail_screen.dart';
import 'package:frontend/views/create_event_screen.dart';

class SupervisorEventListScreen extends StatefulWidget {
  const SupervisorEventListScreen({super.key});

  @override
  _SupervisorEventListScreenState createState() =>
      _SupervisorEventListScreenState();
}

class _SupervisorEventListScreenState extends State<SupervisorEventListScreen> {
  List events = [];
  bool isLoading = true;

  Future<void> fetchEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final role = prefs.getString('user_role');

    if (token == null || role == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final response = await http.get(
      Uri.parse('http://192.168.0.108:5000/api/events'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        events = json.decode(response.body);
        isLoading = false;
      });
    } else {
      print('Failed to fetch events');
      setState(() {
        isLoading = false;
      });
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
        title: const Text('Supervisor - Event List'),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent))
          : events.isEmpty
              ? const Center(
                  child: Text(
                    "No events found.",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  itemCount: events.length,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        title: Text(
                          event['event_name'],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(event['description']),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: Colors.blueAccent),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SupervisorEventDetailsScreen(event: event),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateEventScreen()),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Create Event',
      ),
    );
  }
}
