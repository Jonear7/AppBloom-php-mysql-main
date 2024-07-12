import 'package:bloom/main.dart';

class Room {
  final int roomId;
  final int roomNumber;
  final int rmtypeId;
  final String status;
  final RoomType rmtype;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;

  Room({
    required this.roomId,
    required this.roomNumber,
    required this.rmtypeId,
    required this.status,
    required this.rmtype,
    this.checkInDate,
    this.checkOutDate,
  });

  factory Room.fromJson(Map<String, dynamic> json, RoomType roomType) {
    return Room(
      roomId: json['room_id'] != null
          ? int.tryParse(json['room_id'].toString()) ?? 0
          : 0,
      roomNumber: json['room_number'] != null
          ? int.tryParse(json['room_number'].toString()) ?? 0
          : 0,
      rmtypeId: json['rmtype_id'] != null
          ? int.tryParse(json['rmtype_id'].toString()) ?? 0
          : 0,
      status: json['status'] ?? 'Unavailable',
      rmtype: roomType,
      checkInDate: json['checkin_date'] != null
          ? DateTime.tryParse(json['checkin_date'])
          : null,
      checkOutDate: json['checkout_date'] != null
          ? DateTime.tryParse(json['checkout_date'])
          : null,
    );
  }

  bool isAvailable() {
    final now = DateTime.now();
    if (checkInDate != null && checkOutDate != null) {
      return now.isBefore(checkInDate!) || now.isAfter(checkOutDate!);
    }
    return status.toLowerCase() == 'available';
  }

  bool isBooked() {
    return status.toLowerCase() == 'booked';
  }
}


class RoomType {
  final int rmtypeId;
  final String typeName;
  final String description;
  final List<String> imageUrls;
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
        rmtypeId: json['rmtype_id'] != null
            ? int.tryParse(json['rmtype_id'].toString()) ?? 0
            : 0,
        typeName: json['type_name'] ?? '',
        description: json['description'] ?? '',
        imageUrls: imageUrls,
        price: json['price'] != null
            ? double.tryParse(json['price'].toString()) ?? 0.0
            : 0.0,
      );
    } catch (e) {
      print('Error parsing JSON: $e');
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
