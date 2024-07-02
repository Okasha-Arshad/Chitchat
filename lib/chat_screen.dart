import 'dart:convert';
import 'package:flutter/material.dart';
import 'websocket_service.dart';
import 'services/auth_services.dart';
import 'package:http/http.dart' as http;
import 'utils/constants.dart';
import 'models/message.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String recipientId;

  ChatScreen({required this.userId, required this.recipientId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final WebSocketService _webSocketService = WebSocketService();
  final TextEditingController _controller = TextEditingController();
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _webSocketService.connect('ws://localhost:3000');
    _webSocketService.messages.listen((message) {
      print('Message received: $message');
      final data = jsonDecode(message);
      if (data['type'] == 'message' &&
          (data['senderId'] == widget.recipientId ||
              data['recipientId'] == widget.userId)) {
        setState(() {
          _messages.add(Message(
            senderId: data['senderId'],
            receiverId: widget.userId,
            content: data['text'],
            timestamp: DateTime.now(),
          ));
        });
      }
    });

    // Log in the user to WebSocket
    _webSocketService.sendMessage('', widget.userId, widget.userId, 'login');
  }

  void _fetchMessages() async {
    final response = await http.get(
      Uri.parse(
          '${Constants.uri}/api/auth/messages?senderId=${widget.userId}&receiverId=${widget.recipientId}'),
    );

    if (response.statusCode == 200) {
      List<dynamic> messagesJson = jsonDecode(response.body);
      setState(() {
        _messages = messagesJson.map((json) => Message.fromMap(json)).toList();
      });
    } else {
      print('Failed to load messages: ${response.statusCode}');
    }
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      _webSocketService.sendMessage(
          _controller.text, widget.recipientId, widget.userId, 'message');
      setState(() {
        _messages.add(Message(
          senderId: widget.userId,
          receiverId: widget.recipientId,
          content: _controller.text,
          timestamp: DateTime.now(),
        ));
      });

      // Save message to backend
      final response = await http.post(
        Uri.parse('${Constants.uri}/api/auth/messages/send'),
        body: jsonEncode({
          'senderId': widget.userId,
          'receiverId': widget.recipientId,
          'content': _controller.text,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 201) {
        print('Failed to send message: ${response.statusCode}');
      }

      _controller.clear();
    }
  }

  void _logout() {
    AuthService authService = AuthService();
    authService.signOutUser(context);
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message.senderId == widget.userId;
                return ListTile(
                  title: Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      color: isMe ? Colors.blue : Colors.grey,
                      child: Text(
                        message.content,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
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
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Enter a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
