// import 'package:flutter/material.dart';
// import 'package:frontend/views/animated_circular_progress_indicator.dart';

// class SupervisorEventDetailsScreen extends StatelessWidget {
//   final dynamic event;

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
//             // Event general information
//             Text('Description: ${event['description']}'),
//             const SizedBox(height: 8),
//             Text('Location: ${event['location']}'),
//             Text('Start Date: ${event['start_date']}'),
//             Text('End Date: ${event['end_date']}'),
//             const SizedBox(height: 16),

//             // Tasks section - Supervisor can manage tasks
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

class SupervisorEventDetailsScreen extends StatelessWidget {
  final dynamic event;

  const SupervisorEventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event['event_name']),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event general information
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📌 Description: ${event['description']}',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('📍 Location: ${event['location']}',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('📅 Start Date: ${event['start_date']}',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('⏳ End Date: ${event['end_date']}',
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tasks section - Supervisor can manage tasks
            const Text(
              'Tasks:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...event['tasks'].map<Widget>((task) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  title: Text(
                    task['task_name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Status: ${task['status']}',
                    style: TextStyle(
                      color: task['status'] == 'Completed'
                          ? Colors.green
                          : Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(Icons.edit, color: Colors.blueAccent),
                  onTap: () {
                    // Navigate to task edit screen (Future Implementation)
                  },
                ),
              );
            }).toList(),

            const SizedBox(height: 16),

            // Event progress with animation
            const Text(
              'Progress:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Center(
              child: AnimatedCircularProgressIndicator(
                  progress: event['progress']),
            ),
          ],
        ),
      ),
    );
  }
}
