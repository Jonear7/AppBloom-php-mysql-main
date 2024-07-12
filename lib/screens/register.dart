import 'dart:convert';

import 'package:bloom/main.dart';
import 'package:bloom/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<String> checkEmail() async {
    var url = Uri.parse("http://$API_IP_ADDRESS/api_bloom/check_email.php");
    try {
      var response = await http.post(url, body: {
        "email": emailController.text,
      });
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return "ServerError";
      }
    } catch (e) {
      return "NetworkError";
    }
  }

  Future<void> register() async {
    // Check if passwords match
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Passwords do not match'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // Check if email is valid and available
    var emailCheckResult = await checkEmail();
    if (emailCheckResult == "InvalidEmailFormat") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid email format. Must be a valid Gmail address.'),
        backgroundColor: Colors.red,
      ));
      return;
    } else if (emailCheckResult == "EmailExists") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Email already exists'),
        backgroundColor: Colors.red,
      ));
      return;
    } else if (emailCheckResult == "NetworkError") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Network error. Please try again later.'),
        backgroundColor: Colors.red,
      ));
      return;
    } else if (emailCheckResult == "ServerError") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Server error. Please try again later.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    var url = Uri.parse("http://$API_IP_ADDRESS/api_bloom/register.php");
    try {
      var response = await http.post(url, body: {
        "username": usernameController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "password": passwordController.text,
      });
      var data = json.decode(response.body);
      if (data == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Registration Successful'),
          backgroundColor: Colors.green,
        ));
        await Future.delayed(Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Registration failed. Please try again.'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred. Please try again later.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/onboarding1.jpg'), // Change image path here
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  controller: usernameController,
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  controller: emailController,
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    prefixIcon: Icon(Icons.phone),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  controller: phoneController,
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  obscureText: true,
                  controller: passwordController,
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  obscureText: true,
                  controller: confirmPasswordController,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                  ),
                  onPressed: register,
                  child: Text('Register', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text('Already have an account? Login', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
