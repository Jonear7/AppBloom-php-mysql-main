import 'dart:convert';
import 'dart:math';
import 'package:bloom/details/room_detail.dart';
import 'package:bloom/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Room {
  final int roomId;
  final int rmtypeId;
  final String status;
  final RoomType rmtype;

  Room({
    required this.roomId,
    required this.rmtypeId,
    required this.status,
    required this.rmtype,
  });

  factory Room.fromJson(Map<String, dynamic> json, RoomType roomType) {
    return Room(
      roomId: json['room_id'] != null
          ? int.tryParse(json['room_id'].toString()) ?? 0
          : 0,
      rmtypeId: json['rmtype_id'] != null
          ? int.tryParse(json['rmtype_id'].toString()) ?? 0
          : 0,
      status: json['status'] ?? 'Unavailable',
      rmtype: roomType,
    );
  }

  bool isAvailable() {
    return status.toLowerCase() == 'available';
  }
}

class RoomType {
  final int rmtypeId;
  final String typeName;
  final String description;
  final List<String> imageUrls; // List of image URLs
  final double price;

  RoomType({
    required this.rmtypeId,
    required this.typeName,
    required this.description,
    required this.imageUrls,
    required this.price,
  });
factory RoomType.fromJson(Map<String, dynamic> json) {
  try {
    List<String> imageUrls = [];
      if (json['imageUrls'] != null) {
        imageUrls = (json['imageUrls'] as List)
            .map((imageUrl) =>
                'http://$API_IP_ADDRESS/api_bloom/uploads/$imageUrl')
            .toList();
      }
    return RoomType(
      rmtypeId: json['rmtype_id'] != null ? int.tryParse(json['rmtype_id'].toString()) ?? 0 : 0,
      typeName: json['type_name'] ?? '',
      description: json['description'] ?? '',
      imageUrls: imageUrls,
      price: json['price'] != null ? double.tryParse(json['price'].toString()) ?? 0.0 : 0.0,
    );
  } catch (e) {
    // Print or handle the error
    print('Error parsing JSON: $e');
    // Return a default RoomType or throw an exception
    return RoomType(
      rmtypeId: 0,
      typeName: '',
      description: '',
      imageUrls: [],
      price: 0.0,
    );
  }
}

}

class RoomListScreen extends StatelessWidget {
  late final int userId;

   Future<List<Room>> fetchRoomData() {
    var roomUrl = 'http://$API_IP_ADDRESS/api_bloom/room.php';
    var rmtypeUrl = 'http://$API_IP_ADDRESS/api_bloom/rmtype.php';

    return http.get(Uri.parse(roomUrl)).then((roomResponse) {
      return http.get(Uri.parse(rmtypeUrl)).then((rmtypeResponse) {
        if (roomResponse.statusCode == 200 && rmtypeResponse.statusCode == 200) {
          final roomJsonResponse = json.decode(roomResponse.body);
          final rmtypeJsonResponse = json.decode(rmtypeResponse.body);

          final rmtypeMap = {
            for (var rmtype in rmtypeJsonResponse) rmtype['rmtype_id']: RoomType.fromJson(rmtype)
          };

          final rooms = List<Room>.from(roomJsonResponse.map((room) {
            final rmtypeId = room['rmtype_id'];
            return Room.fromJson(room, rmtypeMap[rmtypeId] ?? RoomType.fromJson({}));
          }));

          return rooms;
        } else {
          throw Exception('Failed to load room data');
        }
      });
    });
  }

  List<Color> _generateRandomColors(int count) {
    final Random random = Random();
    final List<Color> colors = [];

    for (int i = 0; i < count; i++) {
      final int red = random.nextInt(256);
      final int green = random.nextInt(256);
      final int blue = random.nextInt(256);

      colors.add(Color.fromRGBO(red, green, blue, 1));
    }

    return colors;
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> appBarColors = _generateRandomColors(1);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Booking Room',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        backgroundColor: appBarColors[0],
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Room>>(
        future: fetchRoomData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Room>? roomDataList = snapshot.data;
            return ListView.builder(
              itemCount: roomDataList!.length,
              itemBuilder: (context, index) {
                final Room room = roomDataList[index];
                return GestureDetector(
                  onTap: room.isAvailable()
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoomDetailsScreen(
                                room: room,
                                userId: 0,
                                roomType: room.rmtype,
                              ),
                            ),
                          );
                        }
                      : null, // Disable onTap if room is not available
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 244, 244, 244),
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.network(
                          room.rmtype.imageUrls.isNotEmpty &&
                                  room.rmtype.imageUrls[0].isNotEmpty
                              ? room.rmtype.imageUrls[
                                  0] // Use the first URL in the array
                              : 'https://via.placeholder.com/150',
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              room.rmtype.typeName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: room.isAvailable()
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              child: Text(
                                room.status,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          '\$${room.rmtype.price.toString()}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue, // Change color if needed
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
