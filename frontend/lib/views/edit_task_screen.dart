import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditTaskScreen extends StatefulWidget {
  final Map<String, dynamic> task;
  final String eventId;

  const EditTaskScreen({super.key, required this.task, required this.eventId});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _taskNameController;
  late String _status;
  late DateTime _dueDate;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController(text: widget.task['task_name']);
    _status = widget.task['status'];
    _dueDate = DateTime.parse(widget.task['due_date']);
  }

  Future<void> updateTask() async {
    setState(() {
      _isUpdating = true;
    });

    final url = Uri.parse(
        'http://192.168.0.108:5000/api/events/${widget.eventId}/tasks/${widget.task['_id']}');
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "task_name": _taskNameController.text,
        "status": _status,
        "due_date": _dueDate.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, jsonDecode(response.body)); // Return updated task
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task')),
      );
    }

    setState(() {
      _isUpdating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _taskNameController,
              decoration: const InputDecoration(labelText: 'Task Name'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _status,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _status = value;
                  });
                }
              },
              items: const [
                DropdownMenuItem(value: "Pending", child: Text("Pending")),
                DropdownMenuItem(
                    value: "In Progress", child: Text("In Progress")),
                DropdownMenuItem(value: "Completed", child: Text("Completed")),
              ],
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Due Date: ${_dueDate.toLocal()}'.split(' ')[0]),
                TextButton(
                  child: const Text('Pick Date'),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _dueDate,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2030),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _dueDate = pickedDate;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isUpdating ? null : updateTask,
              child: _isUpdating
                  ? const CircularProgressIndicator()
                  : const Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}
