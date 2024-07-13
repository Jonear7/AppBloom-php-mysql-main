import 'dart:convert';
import 'dart:math';
import 'package:bloom/screens/main_screens/details/room_detail.dart';
import 'package:bloom/main.dart';
import 'package:bloom/models/room_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RoomListScreen extends StatefulWidget {
  @override
  _RoomListScreenState createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  late final int userId;
  String? selectedRoomType;

  Future<List<Room>> fetchRoomData() async {
    var roomUrl = 'http://$API_IP_ADDRESS/api_bloom/room.php';
    var rmtypeUrl = 'http://$API_IP_ADDRESS/api_bloom/rmtype.php';

    final roomResponse = await http.get(Uri.parse(roomUrl));
    final rmtypeResponse = await http.get(Uri.parse(rmtypeUrl));

    if (roomResponse.statusCode == 200 && rmtypeResponse.statusCode == 200) {
      final roomJsonResponse = json.decode(roomResponse.body);
      final rmtypeJsonResponse = json.decode(rmtypeResponse.body);

      final rmtypeMap = {
        for (var rmtype in rmtypeJsonResponse)
          rmtype['rmtype_id']: RoomType.fromJson(rmtype)
      };

      final rooms = List<Room>.from(roomJsonResponse.map((room) {
        final rmtypeId = room['rmtype_id'];
        return Room.fromJson(
            room, rmtypeMap[rmtypeId] ?? RoomType.fromJson({}));
      }));

      return rooms;
    } else {
      throw Exception('Failed to load room data');
    }
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              hint: Text("Select Room Type"),
              value: selectedRoomType,
              onChanged: (newValue) {
                setState(() {
                  selectedRoomType = newValue;
                });
              },
              items: <String>[
                'Deluxe',
                'Superior Double',
                'Superior Twin',
                'Junior'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Room>>(
              future: fetchRoomData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final List<Room>? roomDataList = snapshot.data;
                  List<Room> availableRooms = roomDataList!
                      .where((room) => room.isAvailable())
                      .toList();

                  if (selectedRoomType != null) {
                    availableRooms = availableRooms
                        .where(
                            (room) => room.rmtype.typeName == selectedRoomType)
                        .toList();
                  }

                  if (availableRooms.isEmpty) {
                    return Center(
                      child: Text(
                        'No rooms available.',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: availableRooms.length,
                    itemBuilder: (context, index) {
                      final Room room = availableRooms[index];
                      return GestureDetector(
                        onTap: () {
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
                        },
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                    ? room.rmtype.imageUrls[0]
                                    : 'https://via.placeholder.com/150',
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    room.rmtype.typeName,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    ' ${room.roomNumber}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.green,
                                    ),
                                    child: Text(
                                      'Available',
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
                                  color: Colors.blue,
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
          ),
        ],
      ),
    );
  }
}
