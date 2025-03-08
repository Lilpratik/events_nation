import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EventManagerChatScreen extends StatefulWidget {
  final String eventId;

  const EventManagerChatScreen({super.key, required this.eventId});

  @override
  _EventManagerChatScreenState createState() => _EventManagerChatScreenState();
}

class _EventManagerChatScreenState extends State<EventManagerChatScreen> {
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _messageController = TextEditingController();

  Future<void> fetchMessages() async {
    final response = await http.get(
      Uri.parse('http://192.168.0.108:5000/api/messages/${widget.eventId}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        messages = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print('Failed to fetch messages');
    }
  }

  Future<void> sendMessage(String message) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.post(
      Uri.parse('http://192.168.0.108:5000/api/messages/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'eventId': widget.eventId,
        'message': message,
        'sender': 'Event Manager'
      }),
    );

    if (response.statusCode == 201) {
      _messageController.clear();
      fetchMessages();
    } else {
      print('Failed to send message');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat with Client')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message['message']),
                  subtitle: Text(message['sender']),
                  trailing: message['sender'] == 'Event Manager'
                      ? null
                      : const SizedBox(),
                  leading: message['sender'] == 'Event Manager'
                      ? const SizedBox()
                      : null,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:
                        const InputDecoration(hintText: 'Enter message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      sendMessage(_messageController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
