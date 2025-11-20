import 'package:flutter/material.dart';
import '../shared/leaderboard_screen.dart';
import '../lecturer/lecturer_profile_screen.dart';
import '../lecturer/lecturer_dashboard_screen.dart';

class LecturerBottomNav extends StatefulWidget {
  const LecturerBottomNav({super.key});

  @override
  State<LecturerBottomNav> createState() => _LecturerBottomNavState();
}

class _LecturerBottomNavState extends State<LecturerBottomNav> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    LecturerDashboardScreen(),
    LeaderboardScreen(),
    LecturerProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
