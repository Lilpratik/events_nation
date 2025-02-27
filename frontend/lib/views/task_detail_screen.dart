import 'package:flutter/material.dart';

class TaskDetailsScreen extends StatelessWidget {
  final dynamic task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Name: ${task['task_name']}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Status: ${task['status']}'),
            Text('Assigned To: ${task['assigned_to']}'),
            Text('Due Date: ${task['due_date']}'),
            const SizedBox(height: 16),
            const Text('More Task Details:'),
            const Text(
                'Task Details Go Here...'), // You can add any additional info here
          ],
        ),
      ),
    );
  }
}
