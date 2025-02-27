// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:frontend/views/supervisor_event_detail_screen.dart';

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
//       Uri.parse('http://192.168.0.106:5000/api/events'),
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
//       appBar: AppBar(title: const Text('Supervisor - Event List')),
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
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

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
//       Uri.parse('http://192.168.0.106:5000/api/events'),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         events = json.decode(response.body);
//       });
//     } else {
//       print('Failed to fetch events: ${response.body}');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchEvents();
//   }

//   Future<void> createEvent(Map<String, dynamic> eventData) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');

//     if (token == null) {
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }

//     final response = await http.post(
//       Uri.parse('http://192.168.0.106:5000/api/events/'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: json.encode(eventData),
//     );

//     if (response.statusCode == 201) {
//       print('Event created successfully');
//       fetchEvents(); // Refresh event list after creation
//     } else {
//       print('Failed to create event: ${response.body}');
//     }
//   }

//   void navigateToCreateEventScreen(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Scaffold(
//           appBar: AppBar(title: const Text('Create Event')),
//           body: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: CreateEventForm(
//               onCreateEvent: (eventData) {
//                 createEvent(eventData);
//                 Navigator.pop(context); // Return to event list
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Supervisor - Event List'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             tooltip: 'Create Event',
//             onPressed: () => navigateToCreateEventScreen(context),
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
//                     builder: (context) =>
//                         SupervisorEventDetailsScreen(event: event),
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

// class SupervisorEventDetailsScreen extends StatelessWidget {
//   final Map<String, dynamic> event;

//   const SupervisorEventDetailsScreen({super.key, required this.event});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(event['event_name'])),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Description: ${event['description']}'),
//             const SizedBox(height: 8),
//             Text('Location: ${event['location']}'),
//             const SizedBox(height: 8),
//             Text('Start Date: ${event['start_date']}'),
//             const SizedBox(height: 8),
//             Text('End Date: ${event['end_date']}'),
//             const SizedBox(height: 8),
//             Text('Budget: \$${event['budget']}'),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CreateEventForm extends StatefulWidget {
//   final Function(Map<String, dynamic>) onCreateEvent;

//   const CreateEventForm({super.key, required this.onCreateEvent});

//   @override
//   _CreateEventFormState createState() => _CreateEventFormState();
// }

// class _CreateEventFormState extends State<CreateEventForm> {
//   final _formKey = GlobalKey<FormState>();
//   final Map<String, dynamic> _formData = {
//     'event_name': '',
//     'description': '',
//     'location': '',
//     'start_date': '',
//     'end_date': '',
//     'expected_date': '',
//     'budget': 0,
//     'assigned_supervisor': '',
//     'assigned_event_manager': '',
//     'client_id': '',
//     'tasks': [],
//     'progress': 0,
//   };

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       widget.onCreateEvent(_formData);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Event Name'),
//               onSaved: (value) => _formData['event_name'] = value ?? '',
//               validator: (value) =>
//                   value!.isEmpty ? 'Please enter the event name' : null,
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Description'),
//               onSaved: (value) => _formData['description'] = value ?? '',
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Location'),
//               onSaved: (value) => _formData['location'] = value ?? '',
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Start Date'),
//               onSaved: (value) => _formData['start_date'] = value ?? '',
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'End Date'),
//               onSaved: (value) => _formData['end_date'] = value ?? '',
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Expected Date'),
//               onSaved: (value) => _formData['expected_date'] = value ?? '',
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Budget'),
//               keyboardType: TextInputType.number,
//               onSaved: (value) =>
//                   _formData['budget'] = int.tryParse(value ?? '0') ?? 0,
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Supervisor ID'),
//               onSaved: (value) =>
//                   _formData['assigned_supervisor'] = value ?? '',
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Event Manager ID'),
//               onSaved: (value) =>
//                   _formData['assigned_event_manager'] = value ?? '',
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Client ID'),
//               onSaved: (value) => _formData['client_id'] = value ?? '',
//             ),
//             ElevatedButton(
//               onPressed: _submitForm,
//               child: const Text('Create Event'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:frontend/views/supervisor_event_detail_screen.dart';
import 'package:frontend/views/create_event_screen.dart'; // Import your Create Event Screen
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SupervisorEventListScreen(),
        '/create-event': (context) =>
            const CreateEventScreen(), // Define the Create Event route
      },
    );
  }
}

class SupervisorEventListScreen extends StatefulWidget {
  const SupervisorEventListScreen({super.key});

  @override
  _SupervisorEventListScreenState createState() =>
      _SupervisorEventListScreenState();
}

class _SupervisorEventListScreenState extends State<SupervisorEventListScreen> {
  List events = [];

  Future<void> fetchEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final response = await http.get(
      Uri.parse('http://192.168.0.106:5000/api/events'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        events = json.decode(response.body);
      });
    } else {
      print('Failed to fetch events: ${response.body}');
    }
  }

  void navigateToCreateEventScreen(BuildContext context) {
    Navigator.pushNamed(context, '/create-event'); // Navigate to the route
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create Event',
            onPressed: () =>
                navigateToCreateEventScreen(context), // Handle navigation
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(event['event_name']),
              subtitle: Text(event['description']),
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
    );
  }
}

class CreateEventScreen extends StatelessWidget {
  const CreateEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
      body: const Center(
        child: Text('Create Event Screen'),
      ),
    );
  }
}
