
import 'package:bloom/screens/main_screens/booking.dart';
import 'package:bloom/screens/main_screens/home.dart';


import 'package:bloom/screens/main_screens/profile.dart';
import 'package:bloom/screens/main_screens/room.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final PageController _pageController = PageController(initialPage: 0);

  final List<Widget> _pages = [
    HomeScreen(),
    RoomListScreen(), 
    BookingListScreen(),
    ProfileScreen(),
  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(), // Disable page swiping
        onPageChanged: (index) {
          setState(() {});
        },
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255), // Set background color to purple
        color: Color.fromARGB(255, 119, 53, 185), // Set the color of the icons to blue
        buttonBackgroundColor: Color.fromARGB(255, 179, 143, 216), // Set the color of the active icon to blue
        height: 57,
        animationDuration: Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        items: const <Widget>[
          Icon(Icons.home, size: 35),
          Icon(Icons.book, size: 35),
          Icon(Icons.library_books, size: 35),
          Icon(Icons.account_circle, size: 35),
        ],
        onTap: (index) {
          setState(() {
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 220),
              curve: Curves.easeInOut,
            );
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}