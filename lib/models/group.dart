class Group {
  final String id;
  final String name;

  Group({required this.id, required this.name});

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'].toString(),
      name: map['name'],
    );
  }
}

class GroupMessage {
  final String groupId;
  final String senderId;
  final String content;
  final DateTime timestamp;

  GroupMessage({
    required this.groupId,
    required this.senderId,
    required this.content,
    required this.timestamp,
  });

  factory GroupMessage.fromMap(Map<String, dynamic> map) {
    return GroupMessage(
      groupId: map['group_id'].toString(),
      senderId: map['sender_id'].toString(),
      content: map['content'],
      timestamp: DateTime.parse(map['created_at']),
    );
  }
}
