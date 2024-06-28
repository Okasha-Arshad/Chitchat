import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'gradient_background.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    CallsScreen(),
    ContactsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.blue,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Home',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search, color: Colors.white),
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/man-973585_960_720.jpg'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView(
              children: [
                RecentChatCard(
                  name: 'Alex Linderson',
                  message: 'How are you today?',
                  time: '2 min ago',
                  isOnline: true,
                  unreadCount: 3,
                ),
                RecentChatCard(
                  name: 'Team Align',
                  message: 'Don\'t miss to attend the meeting.',
                  time: '2 min ago',
                  isOnline: true,
                  unreadCount: 0,
                ),
                RecentChatCard(
                  name: 'John Ahraham',
                  message: 'Hey! Can you join the meeting?',
                  time: '2 min ago',
                  isOnline: true,
                  unreadCount: 0,
                ),
                RecentChatCard(
                  name: 'Sabila Sayma',
                  message: 'How are you today?',
                  time: '2 min ago',
                  isOnline: false,
                  unreadCount: 0,
                ),
                RecentChatCard(
                  name: 'John Borino',
                  message: 'Have a good day!',
                  time: '2 min ago',
                  isOnline: true,
                  unreadCount: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CallsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Calls',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search, color: Colors.white),
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/man-973585_960_720.jpg'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue[100],
            ),
            child: Center(
              child: Text(
                'Recent',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                CallCard(
                  name: 'Team Align',
                  time: 'Today, 09:30 AM',
                  callType: CallType.missed,
                ),
                CallCard(
                  name: 'Jhon Abraham',
                  time: 'Today, 07:30 AM',
                  callType: CallType.outgoing,
                ),
                CallCard(
                  name: 'Sabila Sayma',
                  time: 'Yesterday, 07:35 PM',
                  callType: CallType.incoming,
                ),
                CallCard(
                  name: 'Alex Linderson',
                  time: 'Monday, 09:30 AM',
                  callType: CallType.incoming,
                ),
                CallCard(
                  name: 'Jhon Abraham',
                  time: '03/07/22, 07:30 AM',
                  callType: CallType.missed,
                ),
                CallCard(
                  name: 'John Borino',
                  time: 'Monday, 09:30 AM',
                  callType: CallType.outgoing,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContactsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 30, left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Contacts',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.person_add_alt_1,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (BuildContext context, int index) {
                return ContactCard(
                  name: 'Contact $index',
                  subtitle: 'Contact subtitle $index',
                  imagePath:
                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/man-973585_960_720.jpg',
                  isOnline: index % 2 == 0,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ContactCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String imagePath;
  final bool isOnline;

  const ContactCard({
    Key? key,
    required this.name,
    required this.subtitle,
    required this.imagePath,
    required this.isOnline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(imagePath),
            ),
            if (isOnline)
              Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                child: SizedBox(
                  width: 10,
                  height: 10,
                ),
              ),
          ],
        ),
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 14.0),
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: Icon(Icons.more_vert),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    'https://cdn.pixabay.com/photo/2015/10/05/22/37/man-973585_960_720.jpg'),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Nazrul Islam',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 4),
            Center(
              child: Text(
                'Never give up 💪',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            SettingItem(
              title: 'Account',
              subtitle: 'Privacy, security, change number',
              icon: Icons.key,
            ),
            SettingItem(
              title: 'Chat',
              subtitle: 'Chat history, theme, wallpapers',
              icon: Icons.chat,
            ),
            SettingItem(
              title: 'Notifications',
              subtitle: 'Messages, group and others',
              icon: Icons.notifications,
            ),
            SettingItem(
              title: 'Invite a friend',
              icon: Icons.person_add_alt_1,
            ),
          ],
        ),
      ),
    );
  }
}

enum CallType { incoming, outgoing, missed }

class CallCard extends StatelessWidget {
  final String name;
  final String time;
  final CallType callType;

  const CallCard({
    Key? key,
    required this.name,
    required this.time,
    required this.callType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor;
    Color nameColor;

    switch (callType) {
      case CallType.incoming:
        iconData = Icons.call_received;
        iconColor = Colors.green;
        nameColor = Colors.black;
        break;
      case CallType.outgoing:
        iconData = Icons.call_made;
        iconColor = Colors.blue;
        nameColor = Colors.black;
        break;
      case CallType.missed:
        iconData = Icons.call_missed;
        iconColor = Colors.red;
        nameColor = Colors.black;
        break;
    }
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(
          iconData,
          color: iconColor,
          size: 30,
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: nameColor,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              time,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Icon(
              Icons.videocam,
              color: Colors.grey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class RecentChatCard extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final bool isOnline;
  final int unreadCount;

  RecentChatCard({
    required this.name,
    required this.message,
    required this.time,
    required this.isOnline,
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/man-973585_960_720.jpg'),
            ),
            if (isOnline)
              Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                child: SizedBox(
                  width: 10,
                  height: 10,
                ),
              ),
          ],
        ),
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          message,
          style: TextStyle(fontSize: 14.0),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
            if (unreadCount > 0)
              Container(
                padding: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: Text(
                  unreadCount.toString(),
                  style: TextStyle(fontSize: 10.0, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;

  const SettingItem({
    Key? key,
    required this.title,
    this.subtitle,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
