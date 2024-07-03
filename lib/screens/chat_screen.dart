import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/websocket_service.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/message.dart';

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
  bool _isTyping = false;
  String _status = 'offline';
  String _typingUserId = '';
  String _recipientUsername = 'Loading...';
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _fetchRecipientDetails();
    _webSocketService.connect('ws://localhost:3000');
    _webSocketService.messages.listen((message) {
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
          _isTyping = false; // Clear typing indicator when message is received
        });
      } else if (data['type'] == 'status' &&
          data['userId'] == widget.recipientId) {
        setState(() {
          _status = data['status'];
        });
      } else if (data['type'] == 'typing' &&
          data['userId'] == widget.recipientId) {
        setState(() {
          _typingUserId = data['userId'];
          _isTyping = data['isTyping'];
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

  void _fetchRecipientDetails() async {
    final response = await http.get(
      Uri.parse('${Constants.uri}/api/auth/user/${widget.recipientId}'),
    );

    if (response.statusCode == 200) {
      final userDetails = jsonDecode(response.body);
      setState(() {
        _recipientUsername = userDetails['username'];
      });
    } else {
      print('Failed to load user details: ${response.statusCode}');
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

  void _handleTyping(String value) {
    if (_typingTimer != null) {
      _typingTimer!.cancel();
    }
    _webSocketService.sendTypingStatus(
        widget.userId, widget.recipientId, value.isNotEmpty);
    _typingTimer = Timer(Duration(seconds: 3), () {
      _webSocketService.sendTypingStatus(
          widget.userId, widget.recipientId, false);
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
        leading: IconButton(
          icon: Image.asset('assets/images/back.png'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile_pic.png'),
              radius: 20,
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _recipientUsername,
                  style: TextStyle(color: Color.fromRGBO(0, 14, 8, 1)),
                ),
                Text(
                  _status,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromRGBO(121, 124, 123, 0.5),
                  ),
                ),
                if (_isTyping && _typingUserId == widget.recipientId)
                  Text(
                    'Typing...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromRGBO(121, 124, 123, 0.5),
                    ),
                  ),
              ],
            ),
          ],
        ),
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
                      decoration: BoxDecoration(
                        color: isMe
                            ? Color.fromRGBO(61, 74, 122, 1)
                            : Color.fromRGBO(242, 247, 251, 1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: isMe ? Radius.zero : Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                          bottomRight: isMe ? Radius.circular(12) : Radius.zero,
                        ),
                      ),
                      child: Text(
                        message.content,
                        style: TextStyle(
                          color: isMe
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(0, 14, 8, 1),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Enter a message',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                      ),
                      onChanged: _handleTyping,
                    ),
                  ),
                  IconButton(
                    icon:
                        Icon(Icons.send, color: Color.fromRGBO(61, 74, 122, 1)),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
