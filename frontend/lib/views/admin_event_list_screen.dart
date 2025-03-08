// import 'package:flutter/material.dart';
// import 'package:frontend/views/CreateUserScreen.dart';
// import 'package:frontend/views/admin_event_detail_screen.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class AdminEventListScreen extends StatefulWidget {
//   const AdminEventListScreen({super.key});

//   @override
//   _AdminEventListScreenState createState() => _AdminEventListScreenState();
// }

// class _AdminEventListScreenState extends State<AdminEventListScreen> {
//   List events = [];

//   Future<void> fetchEvents() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');
//     if (token == null) {
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
//         title: const Text('Admin - Event List'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.person_add),
//             onPressed: () {
//               // Navigate to the Create User Screen
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const CreateUserScreen()),
//               );
//             },
//           ),
//         ],
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
//                     builder: (context) => AdminEventDetailsScreen(event: event),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // new code

import 'package:flutter/material.dart';
import 'package:frontend/views/CreateUserScreen.dart';
import 'package:frontend/views/admin_event_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AdminEventListScreen extends StatefulWidget {
  const AdminEventListScreen({super.key});

  @override
  _AdminEventListScreenState createState() => _AdminEventListScreenState();
}

class _AdminEventListScreenState extends State<AdminEventListScreen> {
  List events = [];

  Future<void> fetchEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
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
      });
    } else {
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
        title: const Text('Admin - Event List'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateUserScreen()),
              );
            },
          ),
        ],
      ),
      body: events.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(event['event_name'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Text(event['description'],
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    leading: const Icon(Icons.event, color: Colors.blueAccent),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Colors.blueAccent),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AdminEventDetailsScreen(event: event),
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
