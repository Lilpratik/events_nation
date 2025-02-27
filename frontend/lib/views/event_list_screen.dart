// import 'package:flutter/material.dart';
// import 'package:frontend/views/event_detail_screen.dart'; // Import the EventDetailsScreen
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class EventListScreen extends StatefulWidget {
//   @override
//   _EventListScreenState createState() => _EventListScreenState();
// }

// class _EventListScreenState extends State<EventListScreen> {
//   List events = [];

//   // Fetch events from API
//   Future<void> fetchEvents() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');
//     final role =
//         prefs.getString('user_role'); // Assume you store the role during login

//     if (token == null || role == null) {
//       print('No token or role found, redirecting to login');
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }

//     Uri url;
//     if (role == 'Admin' || role == 'Supervisor') {
//       url = Uri.parse(
//           'http://192.168.0.106:5000/api/events'); // Admin and Supervisor endpoint
//     } else {
//       url = Uri.parse(
//           'http://192.168.0.106:5000/api/events/user/events'); // Client and Event Manager endpoint
//     }

//     final response = await http.get(url, headers: {
//       'Authorization': 'Bearer $token',
//     });

//     if (response.statusCode == 200) {
//       setState(() {
//         events = json.decode(response.body);
//       });
//     } else if (response.statusCode == 401) {
//       print('Unauthorized, redirecting to login');
//       Navigator.pushReplacementNamed(context, '/login');
//     } else {
//       print('Failed to fetch events: ${response.body}');
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
//       appBar: AppBar(title: Text('Event List')),
//       body: ListView.builder(
//         itemCount: events.length,
//         itemBuilder: (context, index) {
//           final event = events[index];
//           return Card(
//             margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//             child: ListTile(
//               title: Text(event['event_name']),
//               subtitle: Text(event['description']),
//               onTap: () {
//                 // Navigate to event details screen and pass the event data
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => EventDetailsScreen(event: event),
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

import 'package:flutter/material.dart';
import 'package:frontend/views/admin_event_list_screen.dart';
// import 'package:frontend/views/admin_screen.dart'; // Import Admin Screen
import 'package:frontend/views/client_event_list_screen.dart';
import 'package:frontend/views/event_manager_event_list_screen.dart';
import 'package:frontend/views/supervisor_event_list_screen.dart';
// import 'package:frontend/views/supervisor_screen.dart'; // Import Supervisor Screen
// import 'package:frontend/views/event_manager_screen.dart'; // Import Event Manager Screen
// import 'package:frontend/views/client_screen.dart'; // Import Client Screen
import 'package:shared_preferences/shared_preferences.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  String? role;

  // Fetch user role and navigate to the corresponding screen
  Future<void> fetchUserRoleAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    role = prefs.getString('user_role'); // Get the role from shared preferences

    if (token == null || role == null) {
      print('No token or role found, redirecting to login');
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    // Navigate to the appropriate screen based on the user's role
    switch (role) {
      case 'Admin':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminEventListScreen()),
        );
        break;
      case 'Supervisor':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const SupervisorEventListScreen()),
        );
        break;
      case 'EventManager':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => EventManagerEventListScreen()),
        );
        break;
      case 'Client':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const ClientEventListScreen()),
        );
        break;
      default:
        print('Invalid role, redirecting to login');
        Navigator.pushReplacementNamed(context, '/login');
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserRoleAndNavigate(); // Fetch user role and navigate to the respective screen
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while determining the user role
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
