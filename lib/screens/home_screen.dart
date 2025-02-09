import 'package:flutter/material.dart';
import 'package:hive/hive.dart'; // Import Hive for storage
import 'athlete_profile_screen.dart'; // Import Athlete Profile Screen

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  HomeScreen({required this.isDarkMode, required this.onThemeChanged});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = "Guest";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data from Hive storage
  _loadUserData() async {
    var box = await Hive.openBox('userDataBox');
    setState(() {
      _userName = box.get('userName', defaultValue: "Guest");
    });
  }

  // Save user data to Hive storage
  _saveUserData(String userName) async {
    var box = await Hive.openBox('userDataBox');
    box.put('userName', userName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
                widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: widget.onThemeChanged,
          ),
        ],
      ),
      drawer: NavigationDrawer(userName: _userName),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildInteractiveCard("Athlete Profile Overview", Icons.person,
                  Colors.blueAccent, context),
              _buildInteractiveCard("Training & Schedule", Icons.fitness_center,
                  Colors.greenAccent, context),
              _buildInteractiveCard("Health Monitoring",
                  Icons.health_and_safety, Colors.redAccent, context),
              _buildInteractiveCard("Performance Tracking", Icons.bar_chart,
                  Colors.purpleAccent, context),
              _buildInteractiveCard("Career Planning", Icons.timeline,
                  Colors.orangeAccent, context),
              _buildInteractiveCard("Financial Management", Icons.attach_money,
                  Colors.tealAccent, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveCard(
      String title, IconData icon, Color cardColor, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == "Athlete Profile Overview") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AthleteProfileScreen()), // Navigate to Athlete Profile Screen
          );
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    icon,
                    size: 40,
                    color: cardColor,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 4),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Tap to explore more details",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  final String userName;

  NavigationDrawer({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.blue],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                  child: Icon(Icons.person, size: 35, color: Colors.blueAccent),
                ),
                SizedBox(height: 8),
                Text(
                  'Welcome $userName',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey),
          ListTile(
            leading: Icon(Icons.dashboard, color: Colors.blueAccent),
            title: Text('Dashboard',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomeScreen(isDarkMode: false, onThemeChanged: () {}))),
          ),
        ],
      ),
    );
  }
}
