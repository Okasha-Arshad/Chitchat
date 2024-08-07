import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_services.dart';
import '../models/user.dart';
import 'create_group_screen.dart';
import 'group_list_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = loadUserDetails();
  }

  Future<User> loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return User(
      id: prefs.getString('userId') ?? '',
      username: prefs.getString('username') ?? '',
      email: prefs.getString('email') ?? '',
      token: prefs.getString('x-auth-token') ?? '',
      password: '', // Password is not needed for display
    );
  }

  void _logout() async {
    AuthService authService = AuthService();
    await authService.signOutUser(context);
  }

  void _navigateToCreateGroup(BuildContext context, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateGroupScreen(userId: userId),
      ),
    );
  }

  void _navigateToGroupList(BuildContext context, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupListScreen(userId: userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder<User>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No user data found'));
          } else {
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Username: ${user.username}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Email: ${user.email}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _navigateToCreateGroup(context, user.id),
                    child: Text('Create Group'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _navigateToGroupList(context, user.id),
                    child: Text('View Groups'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
