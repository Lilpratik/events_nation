// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class CreateEventScreen extends StatefulWidget {
//   const CreateEventScreen({super.key});

//   @override
//   _CreateEventScreenState createState() => _CreateEventScreenState();
// }

// class _CreateEventScreenState extends State<CreateEventScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final Map<String, dynamic> _formData = {
//     'event_name': '',
//     'description': '',
//     'location': '',
//     'start_date': null,
//     'end_date': null,
//     'expected_date': null,
//     'budget': null,
//     'assigned_supervisor': '',
//     'assigned_event_manager': '',
//     'client_username': '',
//     'tasks': [],
//     'progress': 0,
//   };

//   final List<Map<String, dynamic>> _tasks = [];
//   bool _isLoading = false;

//   Future<void> _submitForm() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//     _formKey.currentState!.save();

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('token');

//       final response = await http.post(
//         Uri.parse('http://192.168.0.108:5000/api/events/'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: json.encode(_formData),
//       );

//       final responseData = json.decode(response.body);

//       if (response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text(responseData['message']),
//           backgroundColor: Colors.green,
//         ));
//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text(responseData['message']),
//           backgroundColor: Colors.red,
//         ));
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('An error occurred. Please try again.'),
//         backgroundColor: Colors.red,
//       ));
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _addTask() async {
//     final task = await showDialog<Map<String, dynamic>>(
//       context: context,
//       builder: (ctx) {
//         final taskFormKey = GlobalKey<FormState>();
//         final Map<String, dynamic> taskData = {
//           'task_name': '',
//           'status': '',
//           'due_date': null,
//           'assigned_to': '',
//         };

//         return AlertDialog(
//           title: const Text('Add Task'),
//           content: Form(
//             key: taskFormKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextFormField(
//                   decoration: const InputDecoration(labelText: 'Task Name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Task Name is required';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     taskData['task_name'] = value!;
//                   },
//                 ),
//                 TextFormField(
//                   decoration: const InputDecoration(labelText: 'Status'),
//                   onSaved: (value) {
//                     taskData['status'] = value!;
//                   },
//                 ),
//                 TextFormField(
//                   decoration: const InputDecoration(labelText: 'Assigned To'),
//                   onSaved: (value) {
//                     taskData['assigned_to'] = value!;
//                   },
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final selectedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(2000),
//                       lastDate: DateTime(2100),
//                     );
//                     if (selectedDate != null) {
//                       taskData['due_date'] = selectedDate.toIso8601String();
//                     }
//                   },
//                   child: const Text('Select Due Date'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 if (taskFormKey.currentState!.validate()) {
//                   taskFormKey.currentState!.save();
//                   Navigator.of(ctx).pop(taskData);
//                 }
//               },
//               child: const Text('Add'),
//             ),
//           ],
//         );
//       },
//     );

//     if (task != null) {
//       setState(() {
//         _tasks.add(task);
//         _formData['tasks'] = _tasks;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Create Event')),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: ListView(
//                   children: [
//                     TextFormField(
//                       decoration:
//                           const InputDecoration(labelText: 'Event Name'),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Event Name is required';
//                         }
//                         return null;
//                       },
//                       onSaved: (value) {
//                         _formData['event_name'] = value!;
//                       },
//                     ),
//                     TextFormField(
//                       decoration:
//                           const InputDecoration(labelText: 'Description'),
//                       onSaved: (value) {
//                         _formData['description'] = value ?? '';
//                       },
//                     ),
//                     TextFormField(
//                       decoration: const InputDecoration(labelText: 'Location'),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Location is required';
//                         }
//                         return null;
//                       },
//                       onSaved: (value) {
//                         _formData['location'] = value!;
//                       },
//                     ),
//                     ElevatedButton(
//                       onPressed: () async {
//                         final selectedDate = await showDatePicker(
//                           context: context,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime(2000),
//                           lastDate: DateTime(2100),
//                         );
//                         if (selectedDate != null) {
//                           _formData['start_date'] =
//                               selectedDate.toIso8601String();
//                         }
//                       },
//                       child: const Text('Select Start Date'),
//                     ),
//                     ElevatedButton(
//                       onPressed: _addTask,
//                       child: const Text('Add Task'),
//                     ),
//                     ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: _tasks.length,
//                       itemBuilder: (ctx, i) => ListTile(
//                         title: Text(_tasks[i]['task_name']),
//                         subtitle:
//                             Text('Assigned to: ${_tasks[i]['assigned_to']}'),
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: _submitForm,
//                       child: const Text('Create Event'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class CreateEventScreen extends StatefulWidget {
//   const CreateEventScreen({super.key});

//   @override
//   _CreateEventScreenState createState() => _CreateEventScreenState();
// }

// class _CreateEventScreenState extends State<CreateEventScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final Map<String, dynamic> _formData = {
//     'event_name': '',
//     'description': '',
//     'location': '',
//     'start_date': null,
//     'end_date': null,
//     'expected_date': null,
//     'budget': null,
//     'assigned_supervisor': '',
//     'assigned_event_manager': '',
//     'client_username': '',
//     'tasks': [],
//     'progress': 0,
//   };

//   final List<Map<String, dynamic>> _tasks = [];
//   bool _isLoading = false;

//   Future<void> _submitForm() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//     _formKey.currentState!.save();

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('auth_token');

//       final response = await http.post(
//         Uri.parse('http://192.168.0.108:5000/api/events/'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: json.encode(_formData),
//       );

//       final responseData = json.decode(response.body);

//       if (response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text(responseData['message']),
//           backgroundColor: Colors.green,
//         ));
//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text(responseData['message']),
//           backgroundColor: Colors.red,
//         ));
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('An error occurred. Please try again.'),
//         backgroundColor: Colors.red,
//       ));
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _addTask() async {
//     final task = await showDialog<Map<String, dynamic>>(
//       context: context,
//       builder: (ctx) {
//         final taskFormKey = GlobalKey<FormState>();
//         final Map<String, dynamic> taskData = {
//           'task_name': '',
//           'status': '',
//           'due_date': null,
//           'assigned_to': '',
//         };

//         return AlertDialog(
//           title: const Text('Add Task'),
//           content: Form(
//             key: taskFormKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextFormField(
//                   decoration: const InputDecoration(labelText: 'Task Name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Task Name is required';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     taskData['task_name'] = value!;
//                   },
//                 ),
//                 TextFormField(
//                   decoration: const InputDecoration(labelText: 'Status'),
//                   onSaved: (value) {
//                     taskData['status'] = value!;
//                   },
//                 ),
//                 TextFormField(
//                   decoration: const InputDecoration(labelText: 'Assigned To'),
//                   onSaved: (value) {
//                     taskData['assigned_to'] = value!;
//                   },
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final selectedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(2000),
//                       lastDate: DateTime(2100),
//                     );
//                     if (selectedDate != null) {
//                       taskData['due_date'] = selectedDate.toIso8601String();
//                     }
//                   },
//                   child: const Text('Select Due Date'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 if (taskFormKey.currentState!.validate()) {
//                   taskFormKey.currentState!.save();
//                   Navigator.of(ctx).pop(taskData);
//                 }
//               },
//               child: const Text('Add'),
//             ),
//           ],
//         );
//       },
//     );

//     if (task != null) {
//       setState(() {
//         _tasks.add(task);
//         _formData['tasks'] = _tasks;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Create Event')),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: ListView(
//                   children: [
//                     TextFormField(
//                       decoration:
//                           const InputDecoration(labelText: 'Event Name'),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Event Name is required';
//                         }
//                         return null;
//                       },
//                       onSaved: (value) {
//                         _formData['event_name'] = value!;
//                       },
//                     ),
//                     TextFormField(
//                       decoration:
//                           const InputDecoration(labelText: 'Description'),
//                       onSaved: (value) {
//                         _formData['description'] = value ?? '';
//                       },
//                     ),
//                     ElevatedButton(
//                       onPressed: _addTask,
//                       child: const Text('Add Task'),
//                     ),
//                     ElevatedButton(
//                       onPressed: _submitForm,
//                       child: const Text('Create Event'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

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
    'progress': null,
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
      String? token = prefs.getString('auth_token');

      final response = await http.post(
        Uri.parse('http://192.168.0.108:5000/api/events/'),
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('An error occurred. Please try again.'),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(String fieldKey) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _formData[fieldKey] = selectedDate.toIso8601String();
      });
    }
  }

  Future<void> _addTask() async {
    final task = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) {
        final taskFormKey = GlobalKey<FormState>();
        final Map<String, dynamic> taskData = {
          'task_name': '',
          'status': '',
          'due_date': null,
          'assigned_to': '',
        };

        String? _selectedStatus;

        return AlertDialog(
          title: const Text('Add Task'),
          content: Form(
            key: taskFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Task Name'),
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
                DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: const [
                    DropdownMenuItem(
                      child: Text('Completed'),
                      value: 'Completed',
                    ),
                    DropdownMenuItem(
                      child: Text('In Progress'),
                      value: 'In Progress',
                    ),
                    DropdownMenuItem(
                      child: Text('Pending'),
                      value: 'Pending',
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Status is required';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    taskData['status'] = value!;
                  },
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value as String?;
                    });
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Assigned To'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Assigned To is required';
                    }
                    return null;
                  },
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
                  child: const Text('Select Due Date'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (taskFormKey.currentState!.validate()) {
                  taskFormKey.currentState!.save();
                  Navigator.of(ctx).pop(taskData);
                }
              },
              child: const Text('Add'),
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
      appBar: AppBar(title: const Text('Create Event')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Event Name'),
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
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      onSaved: (value) {
                        _formData['description'] = value ?? '';
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Location'),
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
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _formData['start_date'] =
                                selectedDate.toIso8601String();
                          });
                        }
                      },
                      child: Text(_formData['start_date'] == null
                          ? 'Select Start Date'
                          : _formData['start_date']),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formData['start_date'] == null) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Please select start date first'),
                            backgroundColor: Colors.red,
                          ));
                          return;
                        }
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.parse(_formData['start_date']),
                          firstDate: DateTime.parse(_formData['start_date']),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _formData['end_date'] =
                                selectedDate.toIso8601String();
                          });
                        }
                      },
                      child: Text(_formData['end_date'] == null
                          ? 'Select End Date'
                          : _formData['end_date']),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formData['start_date'] == null) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Please select start date first'),
                            backgroundColor: Colors.red,
                          ));
                          return;
                        }
                        if (_formData['end_date'] == null) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Please select end date first'),
                            backgroundColor: Colors.red,
                          ));
                          return;
                        }
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.parse(_formData['start_date']),
                          firstDate: DateTime.parse(_formData['start_date']),
                          lastDate: DateTime.parse(_formData['end_date']),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _formData['expected_date'] =
                                selectedDate.toIso8601String();
                          });
                        }
                      },
                      child: Text(_formData['expected_date'] == null
                          ? 'Select Expected Date'
                          : _formData['expected_date']),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Budget'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Budget is required';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _formData['budget'] = int.parse(value!);
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Assigned Supervisor'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Assigned Supervisor is required';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _formData['assigned_supervisor'] = value!;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Assigned Event Manager'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Assigned Event Manager is required';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _formData['assigned_event_manager'] = value!;
                      },
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Client Username'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Client Username is required';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _formData['client_username'] = value!;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Progress'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Progress is required';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _formData['progress'] = int.parse(value!);
                      },
                    ),
                    ElevatedButton(
                      onPressed: _addTask,
                      child: const Text('Add Task'),
                    ),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Create Event'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
