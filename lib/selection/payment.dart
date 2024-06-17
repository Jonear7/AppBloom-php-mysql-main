import 'dart:convert';
import 'dart:io';

import 'package:bloom/auth/auth_service.dart';
import 'package:bloom/auth/bottombar.dart';
import 'package:bloom/main.dart';
import 'package:bloom/pages/room.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'package:path_provider/path_provider.dart';

class PaymentScreen extends StatefulWidget {
  final Room room;
  final int roomId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final double totalPrice;
  final int userId;

  PaymentScreen({
    required this.room,
    required this.roomId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.totalPrice,
    required this.userId, required int roomNumber,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late int? _userId;
  File? _image;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    // Fetch user ID from AuthService
    AuthService authService = AuthService();
    int? userId = await authService.getUserId();
    setState(() {
      _userId = userId!;
    });
  }

Future<void> _uploadPaymentImage(File imageFile) async {
  var confirmed = await _showConfirmationDialog();
  if (!confirmed) return;

  var url = 'http://$API_IP_ADDRESS/api_bloom/addpayment.php';
  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.files.add(
    http.MultipartFile(
      'payment_image',
      imageFile.readAsBytes().asStream(),
      imageFile.lengthSync(),
      filename: imageFile.path.split('/').last,
    ),
  );
  request.fields['payment_date'] =
      DateFormat('yyyy-MM-dd').format(DateTime.now());
  
  // Add the payment_total field to the request
  request.fields['payment_total'] = widget.totalPrice.toString();
  
  // Add the user_id field to the request
  request.fields['user_id'] = _userId.toString(); // Assuming _userId is initialized and contains the user's ID

  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var decodedData = json.decode(responseData);
      if (decodedData['status'] == 'success') {
        print('Payment image uploaded successfully');
        var paymentId = decodedData['payment_id'];
        if (paymentId != null) {
          await _processPayment(paymentId);
          return;
        } else {
          throw Exception('Failed to extract payment ID');
        }
      } else {
        throw Exception(decodedData['message'] ?? 'Unknown error');
      }
    } else {
      throw Exception('Failed to upload payment image: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error uploading payment image: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error uploading payment image: $e')),
    );
  }
}




  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to upload this image and process the payment?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true if confirmed
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false if canceled
              },
              child: Text('No'),
            ),
          ],
        );
      },
    ) ?? false; // Return false if dialog is dismissed
  }

  Future<void> _processPayment(int paymentId) async {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    // Prepare booking data
    var bookingData = {
      'user_id': _userId.toString(),
      'room_id': widget.roomId.toString(),
      'checkin_date': dateFormat.format(widget.checkInDate),
      'checkout_date': dateFormat.format(widget.checkOutDate),
      'total_price': widget.totalPrice.toString(),
      'payment_id': paymentId.toString(),
      'room_number': widget.room.roomNumber.toString(),
      'status': 'booked', // Adding the status field
    };
    // Update the URL with your actual endpoint
    var bookingUrl = 'http://$API_IP_ADDRESS/api_bloom/addbooking.php';

    try {
      var response = await http.post(
        Uri.parse(bookingUrl),
        body: json.encode(bookingData),
        headers: {'Content-Type': 'application/json'},
      );

      // Check if booking was successful
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData is String && responseData.contains('<br />')) {
          throw Exception('Unexpected response format: HTML tags found');
        } else if (responseData['status'] == 'success') {
          // Booking was successful
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('Booking successful. Thank you for your reservation!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BottomBar()),
                      ); // Go back to the home screen
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
          return;
        } else {
          throw Exception(responseData['message'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to process booking: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error processing payment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing booking: $e')),
      );
    }
  }

  Future<void> _downloadImage() async {
    const assetImagePath = 'assets/images/Qr.jpg';

    try {
      final ByteData assetImageByteData = await rootBundle.load(assetImagePath);
      final Uint8List assetImageBytes = assetImageByteData.buffer.asUint8List();

      final Directory? directory = await getExternalStorageDirectory();
      if (directory != null) {
        final String imagePath = '${directory.path}/Qr.jpg';
        final File imageFile = File(imagePath);
        await imageFile.writeAsBytes(assetImageBytes);

        final result = await ImageGallerySaver.saveImage(assetImageBytes);

        if (result['isSuccess']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Image downloaded and saved to gallery successfully'),
            ),
          );
        } else {
          throw Exception('Failed to save image to gallery');
        }
      } else {
        throw Exception('Failed to access external storage directory');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Room: ${widget.room.rmtype.typeName}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Check-in Date: ${DateFormat('yyyy-MM-dd').format(widget.checkInDate)}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Check-out Date: ${DateFormat('yyyy-MM-dd').format(widget.checkOutDate)}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Total Price: \$${widget.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Image.asset(
                'assets/images/Qr.jpg',
                height: 200,
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _downloadImage();
                },
                child: const Text('Download Image'),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? pickedImage =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    File imageFile = File(pickedImage.path);
                    setState(() {
                      _image = imageFile;
                    });
                    await _uploadPaymentImage(imageFile);
                  }
                },
                child: const Text('Upload Image & Save Payment'),
              ),
            ),
            SizedBox(height: 16),
            if (_image != null)
              Image.file(
                _image!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}

