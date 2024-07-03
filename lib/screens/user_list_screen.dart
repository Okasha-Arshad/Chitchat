import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calls_screen.dart';
import 'contacts_screen.dart';
import 'settings_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import '../services/user_service.dart';
import '../models/user.dart';
import '../main.dart'; // Import the colors defined in main.dart
import '../widgets/gradient_background.dart'; // Assuming this file contains your gradient background

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<User>> futureUsers;
  String? userId;
  int _currentIndex = 0;
  List<User> _allUsers = [];
  List<User> _filteredUsers = [];
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<Map<String, String>> _dummyUsers = [
    {
      'name': 'Alice',
      'image': 'https://randomuser.me/api/portraits/women/1.jpg'
    },
    {'name': 'Bob', 'image': 'https://randomuser.me/api/portraits/men/2.jpg'},
    {
      'name': 'Charlie',
      'image': 'https://randomuser.me/api/portraits/men/3.jpg'
    },
    {'name': 'Dave', 'image': 'https://randomuser.me/api/portraits/men/4.jpg'},
    {'name': 'Eve', 'image': 'https://randomuser.me/api/portraits/women/5.jpg'},
    {
      'name': 'Faythe',
      'image': 'https://randomuser.me/api/portraits/women/6.jpg'
    },
    {
      'name': 'Grace',
      'image': 'https://randomuser.me/api/portraits/women/7.jpg'
    },
  ];

  @override
  void initState() {
    super.initState();
    loadUserId();
    futureUsers = UserService().fetchUsers();
    _searchController.addListener(_filterUsers);
  }

  void loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = _allUsers.where((user) {
        final usernameLower = user.username.toLowerCase();
        final emailLower = user.email.toLowerCase();
        return usernameLower.contains(query) || emailLower.contains(query);
      }).toList();
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 1:
        return CallsScreen();
      case 2:
        return ContactsScreen();
      case 3:
        return SettingsScreen();
      default:
        return _buildUserListScreen();
    }
  }

  Widget _buildUserListScreen() {
    return FutureBuilder<List<User>>(
      future: futureUsers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Snapshot error: ${snapshot.error}'); // Log the error
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print('No users found'); // Log no users
          return Center(child: Text('No users found'));
        } else {
          _allUsers =
              snapshot.data!.where((user) => user.id != userId).toList();
          _filteredUsers =
              _searchController.text.isEmpty ? _allUsers : _filteredUsers;
          print(
              'Displaying users: $_filteredUsers'); // Log the users being displayed
          return ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
            ),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  //SizedBox(height: 20), // Add some space at the top
                  Image.asset(
                    'assets/images/top_centre_image.png', // Replace with your asset image path
                    height: 30, // Adjust the height as needed
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = _filteredUsers[index];
                        return ListTile(
                          leading: CircleAvatar(
                              child: Text(user.username[0].toUpperCase())),
                          title: Text(user.username),
                          subtitle: Text(user.email),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  userId: userId!,
                                  recipientId: user.id,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildUserAvatars() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _dummyUsers.map((user) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user['image']!),
                  radius: 30, // Increased size of the avatars
                ),
                SizedBox(height: 8),
                Text(
                  user['name']!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            Container(
              height: 270, // Increased height of the container
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      _isSearching
                          ? Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search users...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                ),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Image.asset('assets/images/search.png'),
                                onPressed: _startSearch,
                              ),
                            ),
                      Spacer(),
                      _isSearching
                          ? IconButton(
                              icon: Icon(Icons.arrow_back,
                                  color: Color.fromRGBO(255, 255, 255, 1)),
                              onPressed: _stopSearch,
                            )
                          : Expanded(
                              child: Center(
                                child: Text(
                                  'Home',
                                  style: GoogleFonts.poppins(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                      Spacer(),
                      IconButton(
                        icon: Image.asset('assets/images/profile.png'),
                        iconSize: 30,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  _buildUserAvatars(), // Added user avatars row
                ],
              ),
            ),
            SizedBox(
                height: 20), // Added space between the contents and the avatars
            Expanded(child: _getScreen(_currentIndex)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensure labels are always shown
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/message.png',
              height: 24,
            ),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/call.png',
              height: 24,
            ),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/contacts.png',
              height: 24,
            ),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/settings.png',
              height: 24,
            ),
            label: 'Settings',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor:
            darkBlueColor, // Color of the currently selected item
        unselectedItemColor: greyColor, // Color of the unselected items
        backgroundColor: Color.fromRGBO(
            255, 255, 255, 1), // Background color of the navigation bar
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
