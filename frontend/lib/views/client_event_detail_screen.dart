// import 'package:flutter/material.dart';
// import 'package:frontend/views/animated_circular_progress_indicator.dart';

// class ClientEventDetailsScreen extends StatelessWidget {
//   final dynamic event;

//   const ClientEventDetailsScreen({super.key, required this.event});

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

//             // Tasks section - Client can only view tasks
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

// new code

import 'package:flutter/material.dart';
import 'animated_circular_progress_indicator.dart';

class ClientEventDetailsScreen extends StatelessWidget {
  final dynamic event;

  const ClientEventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event['event_name'],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event general information with spacing and bold labels
            _infoRow('Description', event['description']),
            _infoRow('📍 Location', event['location']),
            _infoRow('📅 Start Date', event['start_date']),
            _infoRow('⏳ End Date', event['end_date']),
            const SizedBox(height: 16),

            // Tasks section with styled text
            const Text('Tasks:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent)),
            const SizedBox(height: 8),
            Column(
              children: event['tasks'].map<Widget>((task) {
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(task['task_name'],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Status: ${task['status']}',
                        style: TextStyle(
                            color: task['status'] == 'Completed'
                                ? Colors.green
                                : Colors.red)),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),
            // Event progress with animation
            const Text('Progress:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent)),
            const SizedBox(height: 8),
            Center(
                child: AnimatedCircularProgressIndicator(
                    progress: event['progress'])),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label: ',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
