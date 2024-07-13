import 'package:bloom/screens/login.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 189, 15, 76)),
                child: Icon(
                  Icons.logout,
                  color: Color.fromARGB(255, 253, 253, 253),
                  size: 25,
                )),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<UserData>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userData = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.blue,
                    
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: Text(
                          'Profile',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold ,color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Username'),
                    subtitle: Text('${userData.username}'),
                  ),
                  ListTile(
                    title: Text('Email'),
                    subtitle: Text('${userData.email}'),
                  ),
                  ListTile(
                    title: Text('Phone'),
                    subtitle: Text('${userData.phone}'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<UserData> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    String email = prefs.getString('email') ?? '';
    String phone = prefs.getString('phone') ?? '';
    // Retrieve other user data in a similar manner

    return UserData(
      username: username,
      email: email,
      phone: phone,
    );
  }

  void _logout(BuildContext context) async {
    // Clear user data from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('username');
    await prefs.remove('password');
    // Remove user ID if you had it stored
    // await prefs.remove('user_id');
    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
