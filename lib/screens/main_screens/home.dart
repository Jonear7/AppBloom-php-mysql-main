import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(MaterialApp(home: HomeScreen()));
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(
                  'assets/images/boom.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeaderSection(),
            SizedBox(height: 20),
            AmenityIconsRow(),
            SizedBox(height: 20),
            Location(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> _sliderImages = [
      'assets/images/onboarding1.jpg',
      'assets/images/onboarding2.jpg',
      'assets/images/onboarding3.jpg',
      'assets/images/p1.jpg',
      'assets/images/p2.jpg',
      'assets/images/p3.jpg',
      'assets/images/p4.jpg',
      'assets/images/p5.jpg',
      'assets/images/p6.jpg',
      'assets/images/p7.jpg',
    ];

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: CarouselSlider.builder(
        itemCount: _sliderImages.length,
        itemBuilder: (BuildContext context, int index, int realIndex) {
          return Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                _sliderImages[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.4,
          viewportFraction: 1.0,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 8),
          enlargeCenterPage: false,
        ),
      ),
    );
  }
}

class AmenityIconsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final iconSize = MediaQuery.of(context).size.width * 0.12;
    final labelStyle = TextStyle(fontSize: 12, color: Colors.black87);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'Hotel Detail',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(),
          child: SizedBox(
            height: iconSize + 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildAmenityIcon(
                    Icons.wifi, 'Free Wi-Fi', iconSize, labelStyle),
                _buildAmenityIcon(Icons.smoking_rooms, 'Non-smoking rooms',
                    iconSize, labelStyle),
                _buildAmenityIcon(
                    Icons.room_service, 'Room service', iconSize, labelStyle),
                _buildAmenityIcon(
                    Icons.restaurant, 'Restaurant', iconSize, labelStyle),
                _buildAmenityIcon(Icons.local_convenience_store,
                    '24-hour front desk', iconSize, labelStyle),
                _buildAmenityIcon(Icons.breakfast_dining_sharp, 'Breakfast',
                    iconSize, labelStyle),
                _buildAmenityIcon(
                    Icons.local_cafe, 'Tea/coffee maker', iconSize, labelStyle),
                _buildAmenityIcon(Icons.local_bar, 'Bar', iconSize, labelStyle),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmenityIcon(
      IconData icon, String label, double iconSize, TextStyle labelStyle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              size: iconSize,
              color: Colors.purple,
            ),
          ),
          SizedBox(height: 8),
          Text(label, style: labelStyle),
        ],
      ),
    );
  }
}

class Location extends StatelessWidget {
  const Location({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.place,
              size:
                  24), // Icon for location pin, you can use Icons.gps_fixed for GPS icon
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Location",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                   "Wat XiengNgeun Alley, Sethathirath Road, XiengNgeun Village, Chanthaboury District, 01000",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
