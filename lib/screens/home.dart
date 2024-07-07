import 'package:flutter/material.dart';
import 'package:movielingo_app/screens/profile.dart';
import 'package:movielingo_app/screens/endpoints.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Screens corresponding to the navigation bar items
    final List<Widget> screens = [
      const Center(child: Text('Welcome to Movielingo')), // Home screen
      const Profile(), // Profile screen
      Endpoints(), // Endpoints screen
      // Add more screens as needed
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home'),
          NavigationDestination(
              selectedIcon: Icon(Icons.person),
              icon: Icon(Icons.person_outlined),
              label: 'Profile'),
          NavigationDestination(
              selectedIcon: Icon(Icons.settings),
              icon: Icon(Icons.settings_outlined),
              label: 'Endpoints'),
          // Add more destinations as needed
        ],
      ),
    );
  }
}
