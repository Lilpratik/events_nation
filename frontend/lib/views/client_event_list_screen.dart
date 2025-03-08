// import 'dart:convert';
// import 'package:frontend/views/client_event_detail_screen.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ClientEventListScreen extends StatefulWidget {
//   const ClientEventListScreen({super.key});

//   @override
//   _ClientEventListScreenState createState() => _ClientEventListScreenState();
// }

// class _ClientEventListScreenState extends State<ClientEventListScreen> {
//   List events = [];

//   Future<void> fetchEvents() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');

//     if (token == null) {
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }

//     final response = await http.get(
//       Uri.parse('http://192.168.0.108:5000/api/events/user/events'),
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
//       appBar: AppBar(title: const Text('Client - Event List')),
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
//                         ClientEventDetailsScreen(event: event),
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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'client_event_detail_screen.dart';

class ClientEventListScreen extends StatefulWidget {
  const ClientEventListScreen({super.key});

  @override
  _ClientEventListScreenState createState() => _ClientEventListScreenState();
}

class _ClientEventListScreenState extends State<ClientEventListScreen> {
  List events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
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
      setState(() {
        isLoading = false;
      });
      print('Failed to fetch events');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client - Event List',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : events.isEmpty
              ? const Center(
                  child: Text('No events available.',
                      style: TextStyle(fontSize: 16)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(event['event_name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        subtitle: Text(event['description']),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: Colors.blueAccent),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ClientEventDetailsScreen(event: event),
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
