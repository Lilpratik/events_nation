import 'package:flutter/material.dart';
import 'package:frontend/views/animated_circular_progress_indicator.dart';
import 'package:frontend/views/task_detail_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  final dynamic event;

  const EventDetailsScreen({super.key, required this.event});

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
            Text(
              'Description: ${event['description']}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Location: ${event['location']}'),
            Text('Start Date: ${event['start_date']}'),
            Text('End Date: ${event['end_date']}'),
            Text('Expected Date: ${event['expected_date']}'),
            Text('Budget: \$${event['budget']}'),
            const SizedBox(height: 16),

            // Tasks section
            const Text('Tasks:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...event['tasks'].map<Widget>((task) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to task details screen and pass the task data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailsScreen(task: task),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text('${task['task_name']}'),
                      subtitle: Text('Status: ${task['status']}'),
                    ),
                  ),
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
