import 'package:circular_fab_bottom_nav/circular_fab_bottom_nav.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circular FAB Bottom Nav Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    _buildPage(
      'Home',
      Icons.home,
      Colors.blue,
      'Welcome to Home Page',
    ),
    _buildPage(
      'Search',
      Icons.search,
      Colors.green,
      'Search for anything here',
    ),
    _buildPage(
      'Profile',
      Icons.person,
      Colors.orange,
      'Your Profile Information',
    ),
    _buildPage(
      'Settings',
      Icons.settings,
      Colors.red,
      'App Settings & Preferences',
    ),
  ];

  static Widget _buildPage(String title, IconData icon, Color color, String description) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: color,
            ),
            SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF111113),
      body: SafeArea(
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: CircularFabBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          CircularBottomNavItem(
            icon: Icon(Icons.home_outlined, size: 26, color: Colors.grey),
            activeIcon: Icon(Icons.home, size: 26, color: Colors.white),
            label: 'Home',
          ),
          CircularBottomNavItem(
            icon: Icon(Icons.search_outlined, size: 26, color: Colors.grey),
            activeIcon: Icon(Icons.search, size: 26, color: Colors.white),
            label: 'Search',
          ),
          CircularBottomNavItem(
            icon: Icon(Icons.person_outline, size: 26, color: Colors.grey),
            activeIcon: Icon(Icons.person, size: 26, color: Colors.white),
            label: 'Profile',
          ),
          CircularBottomNavItem(
            icon: Icon(Icons.settings_outlined, size: 26, color: Colors.grey),
            activeIcon: Icon(Icons.settings, size: 26, color: Colors.white),
            label: 'Settings',
          ),
        ],
        fabOptions: [
          FabOptionItem(
            icon: Icons.headset,
            iconColor: Colors.white,
            backgroundColor: Color(0xFF4CAF50),
            title: 'Album',
            subtitle: 'Select from your album',
            onTap: () {
              _showOptionSelectedDialog('MemPod Mic');
            },
          ),
          FabOptionItem(
            icon: Icons.mic,
            iconColor: Colors.white,
            backgroundColor: Color(0xFF2196F3),
            title: 'Camera',
            subtitle: 'Take a photo and record',
            onTap: () {
              _showOptionSelectedDialog('Extended Mic');
            },
          ),
          FabOptionItem(
            icon: Icons.mic,
            iconColor: Colors.white,
            backgroundColor: Color(0xFF424242),
            title: 'Netdisk',
            subtitle: 'Select from your netdisk',
            onTap: () {
              _showOptionSelectedDialog('Phone Mic');
            },
          ),
        ],
        backgroundColor: Color(0xFF111113),
        fabBackgroundColor: Colors.white,
        fabIconColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  void _showOptionSelectedDialog(String optionName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Option Selected'),
          content: Text('You selected: $optionName'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
