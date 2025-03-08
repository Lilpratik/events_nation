// import 'package:flutter/material.dart';
// import 'package:frontend/views/animated_circular_progress_indicator.dart';

// class AdminEventDetailsScreen extends StatelessWidget {
//   final dynamic event;

//   const AdminEventDetailsScreen({super.key, required this.event});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(event['event_name']),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () {
//               // Navigate to event edit screen (Add edit functionality)
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.delete),
//             onPressed: () {
//               // Handle event deletion (Add delete functionality)
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Event general information
//             Text('Description: ${event['description']}'),
//             const SizedBox(height: 8),
//             Text('Location: ${event['location']}'),
//             Text('Start Date: ${event['start_date']}'),
//             Text('End Date: ${event['end_date']}'),
//             const SizedBox(height: 16),

//             // Tasks section - Admin can manage tasks
//             const Text('Tasks:',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             ...event['tasks'].map<Widget>((task) {
//               return ListTile(
//                 title: Text(task['task_name']),
//                 subtitle: Text('Status: ${task['status']}'),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.edit),
//                   onPressed: () {
//                     // Navigate to task edit screen
//                   },
//                 ),
//               );
//             }).toList(),

//             const SizedBox(height: 16),
//             // Event progress with animation
//             const Text('Progress:',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             AnimatedCircularProgressIndicator(progress: event['progress']),
//           ],
//         ),
//       ),
//     );
//   }
// }

// new code

import 'package:flutter/material.dart';
import 'package:frontend/views/animated_circular_progress_indicator.dart';

class AdminEventDetailsScreen extends StatelessWidget {
  final dynamic event;

  const AdminEventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event['event_name']),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Navigate to event edit screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              // Handle event deletion
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(event['description']),
                    const SizedBox(height: 8),
                    Text('Location: ${event['location']}'),
                    Text('Start Date: ${event['start_date']}'),
                    Text('End Date: ${event['end_date']}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tasks Section
            const Text('Tasks:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            event['tasks'].isEmpty
                ? const Center(child: Text('No tasks available'))
                : Column(
                    children: event['tasks'].map<Widget>((task) {
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(task['task_name'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          subtitle: Text('Status: ${task['status']}'),
                          leading:
                              const Icon(Icons.task, color: Colors.blueAccent),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit,
                                color: Colors.blueAccent),
                            onPressed: () {
                              // Navigate to task edit screen
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),

            const SizedBox(height: 16),
            // Progress Indicator
            const Text('Progress:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            AnimatedCircularProgressIndicator(progress: event['progress']),
          ],
        ),
      ),
    );
  }
}
