import 'dart:convert';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel channel;
  late String url;

  void connect(String url) {
    this.url = url;
    channel = IOWebSocketChannel.connect(url);
    print('WebSocket connected to $url');
  }

  void sendMessage(
      String text, String recipientId, String userId, String? msgType) {
    final message = jsonEncode({
      'type': msgType,
      'recipientId': recipientId,
      'text': text,
      'userId': userId
    });

    print('Sending message: $message');
    channel.sink.add(message);
  }

  Stream get messages => channel.stream;

  void disconnect() {
    channel.sink.close();
    print('WebSocket disconnected');
  }
}
