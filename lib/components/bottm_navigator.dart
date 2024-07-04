import 'package:beatz_musicplayer/pages/user/offline/home_page.dart';
import 'package:beatz_musicplayer/pages/user/online/online_player_screen.dart';
import 'package:beatz_musicplayer/pages/user/online/online_playlist.dart';
import 'package:beatz_musicplayer/pages/user/online/search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavi extends StatefulWidget {
  const BottomNavi({super.key});

  @override
  State<BottomNavi> createState() => _BottomNaviState();
}

class _BottomNaviState extends State<BottomNavi> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const OnlineScreen(),
    const SearchPage(),
    const OnlinePlaylist()
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
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: GNav(
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: FontAwesomeIcons.globe,
                text: 'Online',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                icon: Icons.library_add,
                text: 'Library',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: _onItemTapped,
            activeColor: Colors.white,
            backgroundColor: Colors.black,
            color: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            gap: 8,
            padding: const EdgeInsets.all(16),
          ),
        ),
      ),
    );
  }
}
