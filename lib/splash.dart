// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'dart:async';

import 'package:bloom/auth/auth_service.dart';
import 'package:bloom/auth/bottombar.dart';
import 'package:bloom/auth/login.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3), // Reduce duration for faster splash screen
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();

    Timer(Duration(seconds: 2), () {
      checkLoginAndNavigate(); // Check login status and navigate accordingly
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> checkLoginAndNavigate() async {
    AuthService authService = AuthService();
    bool isLoggedIn = await authService.isLoggedIn();
    if (isLoggedIn) {
      // User is logged in, navigate to BottomBar
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomBar()),
      );
    } else {
      // User is not logged in, navigate to LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Transparent background
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 75, // Adjust the radius as needed
                backgroundColor: Colors.transparent, // Transparent background
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/boom.jpg',
                    width: 150, // Adjust the width as needed
                    height: 150, // Adjust the height as needed
                    fit: BoxFit.cover, // Maintain aspect ratio
                  ),
                ),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
