import 'dart:convert';

import 'package:flutter/material.dart';
import 'websocket_service.dart';

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
  List<Map<String, String>> _messages = [];

  @override
  void initState() {
    super.initState();
    _webSocketService.connect('ws://localhost:3000');
    _webSocketService.messages.listen((message) {
      print('Message received: $message');
      final data = jsonDecode(message);
      if (data['type'] == 'message' &&
          (data['senderId'] == widget.recipientId ||
              data['recipientId'] == widget.userId)) {
        setState(() {
          _messages.add({
            'senderId': data['senderId'],
            'text': data['text'],
          });
        });
      }
    });

    // Log in the user to WebSocket
    _webSocketService.sendMessage('', widget.userId, widget.userId, 'login');
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _webSocketService.sendMessage(
          _controller.text, widget.recipientId, widget.userId, 'message');
      setState(() {
        _messages.add({
          'senderId': widget.userId,
          'text': _controller.text,
        });
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message['senderId'] == widget.userId;
                return ListTile(
                  title: Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      color: isMe ? Colors.blue : Colors.grey,
                      child: Text(
                        message['text']!,
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
