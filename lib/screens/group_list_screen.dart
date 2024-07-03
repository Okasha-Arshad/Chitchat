import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/group.dart';
import '../utils/constants.dart';
import 'group_chat_screen.dart';

class GroupListScreen extends StatefulWidget {
  final String userId;

  GroupListScreen({required this.userId});

  @override
  _GroupListScreenState createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
  late Future<List<Group>> futureGroups;

  @override
  void initState() {
    super.initState();
    futureGroups = _fetchGroups();
  }

  Future<List<Group>> _fetchGroups() async {
    final response = await http.get(
      Uri.parse('${Constants.uri}/api/auth/groups/user/${widget.userId}'),
    );

    if (response.statusCode == 200) {
      List<dynamic> groupsJson = jsonDecode(response.body);
      return groupsJson.map((json) => Group.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load groups');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
      ),
      body: FutureBuilder<List<Group>>(
        future: futureGroups,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No groups found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final group = snapshot.data![index];
                return ListTile(
                  title: Text(group.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupChatScreen(
                          groupId: group.id,
                          userId: widget.userId,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
