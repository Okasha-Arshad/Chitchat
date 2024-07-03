import 'dart:convert';

class Message {
  final String senderId;
  final String receiverId;
  final String content;
  final String? imageUrl; // Add this line
  final DateTime timestamp;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.content,
    this.imageUrl, // Add this line
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'image_url': imageUrl, // Add this line
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['sender_id'].toString(),
      receiverId: map['receiver_id'].toString(),
      content: map['content'] ?? '', // Handle nullable content
      imageUrl: map['image_url'], // Add this line
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));
}
