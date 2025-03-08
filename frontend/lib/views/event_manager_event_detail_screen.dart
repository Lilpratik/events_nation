import 'package:flutter/material.dart';
import 'package:frontend/views/animated_circular_progress_indicator.dart';
import 'package:frontend/views/edit_task_screen.dart';

class EventManagerEventDetailsScreen extends StatefulWidget {
  final dynamic event;

  const EventManagerEventDetailsScreen({super.key, required this.event});

  @override
  _EventManagerEventDetailsScreenState createState() =>
      _EventManagerEventDetailsScreenState();
}

class _EventManagerEventDetailsScreenState
    extends State<EventManagerEventDetailsScreen> {
  late List<dynamic> tasks;

  @override
  void initState() {
    super.initState();
    tasks = List.from(widget.event['tasks']);
  }

  void updateTask(int index, Map<String, dynamic> updatedTask) {
    setState(() {
      tasks[index] = updatedTask;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event['event_name']),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Details
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.event['event_name'],
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(widget.event['description'],
                        style: const TextStyle(fontSize: 16)),
                    const Divider(height: 20, thickness: 2),
                    Text('📍 Location: ${widget.event['location']}',
                        style: const TextStyle(fontSize: 16)),
                    Text('📅 Start Date: ${widget.event['start_date']}',
                        style: const TextStyle(fontSize: 16)),
                    Text('⏳ End Date: ${widget.event['end_date']}',
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Task List
            const Text(
              'Tasks',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              separatorBuilder: (context, index) =>
                  const Divider(thickness: 1, height: 10),
              itemBuilder: (context, index) {
                var task = tasks[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(task['task_name'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    subtitle: Text('Status: ${task['status']}',
                        style: const TextStyle(fontSize: 14)),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.deepPurple),
                      onPressed: () async {
                        final updatedTask = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTaskScreen(
                              task: task,
                              eventId: widget.event['_id'],
                            ),
                          ),
                        );

                        if (updatedTask != null) {
                          updateTask(index, updatedTask);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Progress Indicator
            const Text(
              'Progress',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Center(
              child: AnimatedCircularProgressIndicator(
                  progress: widget.event['progress']),
            ),
          ],
        ),
      ),
    );
  }
}


/// new code
/// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:frontend/views/animated_circular_progress_indicator.dart';
// import 'package:frontend/views/edit_task_screen.dart';

// class EventManagerEventDetailsScreen extends StatefulWidget {
//   final dynamic event;

//   const EventManagerEventDetailsScreen({super.key, required this.event});

//   @override
//   _EventManagerEventDetailsScreenState createState() =>
//       _EventManagerEventDetailsScreenState();
// }

// class _EventManagerEventDetailsScreenState
//     extends State<EventManagerEventDetailsScreen> {
//   late List<dynamic> tasks;

//   @override
//   void initState() {
//     super.initState();
//     tasks = List.from(widget.event['tasks']);
//   }

//   void updateTask(int index, Map<String, dynamic> updatedTask) {
//     setState(() {
//       tasks[index] = updatedTask;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.event['event_name'])),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Event general information
//             Text('Description: ${widget.event['description']}'),
//             const SizedBox(height: 8),
//             Text('Location: ${widget.event['location']}'),
//             Text('Start Date: ${widget.event['start_date']}'),
//             Text('End Date: ${widget.event['end_date']}'),
//             const SizedBox(height: 16),

//             // Tasks section - Event Manager can manage tasks
//             const Text(
//               'Tasks:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             ...tasks.asMap().entries.map<Widget>((entry) {
//               int index = entry.key;
//               var task = entry.value;
//               return ListTile(
//                 title: Text(task['task_name']),
//                 subtitle: Text('Status: ${task['status']}'),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.edit),
//                   onPressed: () async {
//                     final updatedTask = await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => EditTaskScreen(
//                           task: task,
//                           eventId: widget.event['_id'],
//                         ),
//                       ),
//                     );

//                     if (updatedTask != null) {
//                       updateTask(index, updatedTask);
//                     }
//                   },
//                 ),
//               );
//             }).toList(),

//             const SizedBox(height: 16),
//             // Event progress with animation
//             const Text(
//               'Progress:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             AnimatedCircularProgressIndicator(
//                 progress: widget.event['progress']),
//           ],
//         ),
//       ),
//     );
//   }
// }
