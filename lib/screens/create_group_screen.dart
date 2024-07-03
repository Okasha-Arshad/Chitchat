import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/group.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import '../utils/constants.dart';

class CreateGroupScreen extends StatefulWidget {
  final String userId;

  CreateGroupScreen({required this.userId});

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  List<String> _selectedUsers = [];

  Future<void> _createGroup() async {
    final response = await http.post(
      Uri.parse('${Constants.uri}/api/auth/groups/create'),
      body: jsonEncode({'name': _groupNameController.text}),
      headers: {'Content-Type': 'application/json'},
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      final group = Group.fromMap(jsonDecode(response.body));
      await _addUsersToGroup(group.id);
      Navigator.pop(context);
    } else {
      print('Failed to create group: ${response.statusCode}');
    }
  }

  Future<void> _addUsersToGroup(String groupId) async {
    for (var userId in _selectedUsers) {
      final response = await http.post(
        Uri.parse('${Constants.uri}/api/auth/groups/addUser'),
        body: jsonEncode({'groupId': groupId, 'userId': userId}),
        headers: {'Content-Type': 'application/json'},
      );

      print('Add user response status: ${response.statusCode}');
      print('Add user response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _groupNameController,
            decoration: InputDecoration(hintText: 'Group Name'),
          ),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: UserService().fetchUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No users found'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final user = snapshot.data![index];
                      return CheckboxListTile(
                        title: Text(user.username),
                        value: _selectedUsers.contains(user.id),
                        onChanged: (bool? selected) {
                          setState(() {
                            if (selected == true) {
                              _selectedUsers.add(user.id);
                            } else {
                              _selectedUsers.remove(user.id);
                            }
                          });
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: _createGroup,
            child: Text('Create Group'),
          ),
        ],
      ),
    );
  }
}
