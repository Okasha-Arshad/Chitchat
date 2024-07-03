import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/group.dart';
import '../services/websocket_service.dart';
import '../utils/constants.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupId;
  final String userId;

  GroupChatScreen({required this.groupId, required this.userId});

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final WebSocketService _webSocketService = WebSocketService();
  final TextEditingController _controller = TextEditingController();
  List<GroupMessage> _messages = [];
  bool _isTyping = false;
  String _typingUserId = '';
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _webSocketService.connect('ws://localhost:3000');
    _webSocketService.messages.listen((message) {
      final data = jsonDecode(message);
      if (data['type'] == 'group_message' &&
          data['groupId'] == widget.groupId) {
        setState(() {
          _messages.add(GroupMessage(
            groupId: data['groupId'],
            senderId: data['senderId'],
            content: data['text'],
            timestamp: DateTime.now(),
          ));
          _isTyping = false; // Clear typing indicator when message is received
        });
      }
    });

    // Log in the user to WebSocket
    _webSocketService.sendMessage('', widget.userId, widget.userId, 'login');
  }

  void _fetchMessages() async {
    final response = await http.get(
      Uri.parse('${Constants.uri}/api/auth/groups/${widget.groupId}/messages'),
    );

    if (response.statusCode == 200) {
      List<dynamic> messagesJson = jsonDecode(response.body);
      setState(() {
        _messages =
            messagesJson.map((json) => GroupMessage.fromMap(json)).toList();
      });
    } else {
      print('Failed to load messages: ${response.statusCode}');
    }
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      _webSocketService.sendGroupMessage(
          _controller.text, widget.groupId, widget.userId);
      setState(() {
        _messages.add(GroupMessage(
          groupId: widget.groupId,
          senderId: widget.userId,
          content: _controller.text,
          timestamp: DateTime.now(),
        ));
      });

      // Save message to backend
      final response = await http.post(
        Uri.parse(
            '${Constants.uri}/api/auth/groups/${widget.groupId}/messages'),
        body: jsonEncode({
          'senderId': widget.userId,
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

  void _handleTyping(String value) {
    if (_typingTimer != null) {
      _typingTimer!.cancel();
    }
    _webSocketService.sendGroupTypingStatus(
        widget.userId, widget.groupId, value.isNotEmpty);
    _typingTimer = Timer(Duration(seconds: 3), () {
      _webSocketService.sendGroupTypingStatus(
          widget.userId, widget.groupId, false);
    });
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Chat'),
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
                    onChanged: _handleTyping,
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
