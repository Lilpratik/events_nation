// import 'package:flutter/material.dart';
// import 'package:frontend/views/animated_circular_progress_indicator.dart';

// class EventManagerEventDetailsScreen extends StatelessWidget {
//   final dynamic event;

//   const EventManagerEventDetailsScreen({super.key, required this.event});

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

//             // Tasks section - Only view tasks, no edit
//             const Text('Tasks:',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             ...event['tasks'].map<Widget>((task) {
//               return ListTile(
//                 title: Text(task['task_name']),
//                 subtitle: Text('Status: ${task['status']}'),
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

import 'package:flutter/material.dart';
import 'package:frontend/views/animated_circular_progress_indicator.dart';

class EventManagerEventDetailsScreen extends StatelessWidget {
  final dynamic event;

  const EventManagerEventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event['event_name'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event general information
            Text('Description: ${event['description']}'),
            const SizedBox(height: 8),
            Text('Location: ${event['location']}'),
            Text('Start Date: ${event['start_date']}'),
            Text('End Date: ${event['end_date']}'),
            const SizedBox(height: 16),

            // Tasks section - Supervisor can manage tasks
            const Text('Tasks:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...event['tasks'].map<Widget>((task) {
              return ListTile(
                title: Text(task['task_name']),
                subtitle: Text('Status: ${task['status']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to task edit screen
                  },
                ),
              );
            }).toList(),

            const SizedBox(height: 16),
            // Event progress with animation
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
