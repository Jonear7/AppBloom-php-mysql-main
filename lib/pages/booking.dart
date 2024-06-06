import 'dart:convert';
import 'package:bloom/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class BookingListScreen extends StatefulWidget {
  @override
  _BookingListScreenState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  List<dynamic> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    // Retrieve userId from SharedPreferences
    int? userId = await getUserId();

    // Check if userId is not null
    if (userId != null) {
      var url = 'http://$API_IP_ADDRESS/api_bloom/booking.php?user_id=$userId';

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final List<dynamic> fetchedBookings = json.decode(response.body);
          setState(() {
            _bookings = fetchedBookings;
            _isLoading = false;
          });
        } else {
          print('Failed to load bookings: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching bookings: $e');
      }
    } else {
      print('User ID is null');
    }
  }

  Future<int?> getUserId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getInt('user_id');
    } catch (e) {
      print("Error occurred while getting user ID: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Bookings'),
        ),automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _bookings.isEmpty
              ? Center(
                  child: Text('No bookings found for the user.'),
                )
              : ListView.builder(
                  itemCount: _bookings.length,
                  itemBuilder: (context, index) {
                    var booking = _bookings[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Room Name: ${booking['room_name'] ?? 'Loading...'}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text('Check-in Date: ${booking['checkin_date']}'),
                          Text('Check-out Date: ${booking['checkout_date']}'),
                          Text('Total Price: ${booking['total_price']}'),
                          Text('Room Amount: ${booking['room_amount']}'),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
