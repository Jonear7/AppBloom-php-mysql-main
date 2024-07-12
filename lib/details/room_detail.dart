import 'dart:math';
import 'package:bloom/selection/select_booking.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../model/room_model.dart';

class RoomDetailsScreen extends StatelessWidget {
  final Room room;
  final int userId;

  RoomDetailsScreen({required this.room, required this.userId, required RoomType roomType});

  List<Color> _generateRandomColors(int count) {
    Random random = Random();
    List<Color> colors = [];

    for (int i = 0; i < count; i++) {
      int red = random.nextInt(256);
      int green = random.nextInt(256);
      int blue = random.nextInt(256);

      colors.add(Color.fromRGBO(red, green, blue, 1));
    }

    return colors;
  }

  @override
  Widget build(BuildContext context) {
    List<Color> appBarColors = _generateRandomColors(1);
    List<Color> buttonColors = _generateRandomColors(1);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          room.rmtype.typeName,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: appBarColors[0],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carousel slider for room images
              room.rmtype.imageUrls.isNotEmpty && room.rmtype.imageUrls[0].isNotEmpty
                  ? CarouselSlider(
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.width *
                            1.1, // Set carousel height dynamically
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                      ),
                      items: room.rmtype.imageUrls.map((imageUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    )
                  : SizedBox(), // Show nothing if no images available
              SizedBox(height: 16),
              // Container for room description and price
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      room.rmtype.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    Divider(
                      color: Colors.black87,
                      thickness: 1,
                      height: 20,
                    ),
                    Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '\$${room.rmtype.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Button to navigate to booking screen
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(
                        room: room,
                        userId: userId,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColors[0],
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Colors.grey,
                  elevation: 5,
                ),
                child: Center(
                  child: Text(
                    'Book Now',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
