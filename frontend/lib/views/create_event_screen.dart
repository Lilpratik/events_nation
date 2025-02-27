import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'event_name': '',
    'description': '',
    'location': '',
    'start_date': null,
    'end_date': null,
    'expected_date': null,
    'budget': null,
    'assigned_supervisor': '',
    'assigned_event_manager': '',
    'client_username': '',
    'tasks': [],
    'progress': 0,
  };

  final List<Map<String, dynamic>> _tasks = [];
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('http://192.168.0.106:5000/api/events/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(_formData),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message']),
          backgroundColor: Colors.green,
        ));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message']),
          backgroundColor: Colors.red,
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred. Please try again.'),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addTask() async {
    final task = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) {
        final _taskFormKey = GlobalKey<FormState>();
        final Map<String, dynamic> taskData = {
          'task_name': '',
          'status': '',
          'due_date': null,
          'assigned_to': '',
        };

        return AlertDialog(
          title: Text('Add Task'),
          content: Form(
            key: _taskFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Task Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Task Name is required';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    taskData['task_name'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Status'),
                  onSaved: (value) {
                    taskData['status'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Assigned To'),
                  onSaved: (value) {
                    taskData['assigned_to'] = value!;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      taskData['due_date'] = selectedDate.toIso8601String();
                    }
                  },
                  child: Text('Select Due Date'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_taskFormKey.currentState!.validate()) {
                  _taskFormKey.currentState!.save();
                  Navigator.of(ctx).pop(taskData);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );

    if (task != null) {
      setState(() {
        _tasks.add(task);
        _formData['tasks'] = _tasks;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Event')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Event Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Event Name is required';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _formData['event_name'] = value!;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Description'),
                      onSaved: (value) {
                        _formData['description'] = value ?? '';
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Location'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Location is required';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _formData['location'] = value!;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          _formData['start_date'] =
                              selectedDate.toIso8601String();
                        }
                      },
                      child: Text('Select Start Date'),
                    ),
                    ElevatedButton(
                      onPressed: _addTask,
                      child: Text('Add Task'),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _tasks.length,
                      itemBuilder: (ctx, i) => ListTile(
                        title: Text(_tasks[i]['task_name']),
                        subtitle:
                            Text('Assigned to: ${_tasks[i]['assigned_to']}'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Create Event'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
