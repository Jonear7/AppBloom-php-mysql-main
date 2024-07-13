import 'package:bloom/models/room_model.dart';
import 'package:bloom/screens/main_screens/selection/payment.dart';
import 'package:flutter/material.dart';



class BookingScreen extends StatefulWidget {
  final Room room;
  final int userId;

  BookingScreen({
    required this.userId,
    required this.room,
  });

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  double _totalPrice = 0.0;

  void _calculateTotalPrice() {
    if (_checkInDate != null && _checkOutDate != null) {
      // Calculate the number of days between check-in and check-out
      final int numberOfDays = _checkOutDate!.difference(_checkInDate!).inDays;
      // Calculate the total price by multiplying the number of days and room price
      setState(() {
        _totalPrice = widget.room.rmtype.price * numberOfDays;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _calculateTotalPrice(); // Calculate the initial total price
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${widget.room.rmtype.typeName}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoomImageSection(room: widget.room),
              SizedBox(height: 16),
              BookingDetailsSection(
                checkInDate: _checkInDate,
                checkOutDate: _checkOutDate,
                onCheckInDateSelected: (date) {
                  setState(() {
                    _checkInDate = date;
                    _calculateTotalPrice(); // Recalculate total price when check-in date changes
                  });
                },
                onCheckOutDateSelected: (date) {
                  setState(() {
                    _checkOutDate = date;
                    _calculateTotalPrice(); // Recalculate total price when check-out date changes
                  });
                },
              ),
              SizedBox(height: 16),
              TotalPriceSection(totalPrice: _totalPrice),
              SizedBox(height: 16),
              PaymentButton(
                onPressed: (_checkInDate != null && _checkOutDate != null)
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(
                              roomId: widget.room.roomId,
                              userId: widget.userId,
                              checkInDate: _checkInDate!,
                              checkOutDate: _checkOutDate!,
                              totalPrice: _totalPrice,
                              room: widget.room,
                              roomNumber: widget.room.roomNumber,
                            ),
                          ),
                        );
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoomImageSection extends StatelessWidget {
  final Room room;

  RoomImageSection({required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.width * 0.6,
              child: room.rmtype.imageUrls.isNotEmpty
                  ? Image.network(
                      room.rmtype.imageUrls[0],
                      fit: BoxFit.cover,
                    )
                  : Placeholder(), // Placeholder widget if imageUrls is empty
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                '\$${room.rmtype.price.toStringAsFixed(2)}',
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
    );
  }
}

class BookingDetailsSection extends StatelessWidget {
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final Function(DateTime)? onCheckInDateSelected;
  final Function(DateTime)? onCheckOutDateSelected;

  BookingDetailsSection({
    required this.checkInDate,
    required this.checkOutDate,
    required this.onCheckInDateSelected,
    required this.onCheckOutDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter your booking details below:',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 16),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromARGB(255, 183, 7, 196),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );
                    if (picked != null && onCheckInDateSelected != null) {
                      onCheckInDateSelected!(picked);
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today,
                          color: const Color.fromARGB(255, 247, 247, 247)),
                      SizedBox(width: 8),
                      Center(
                        child: Text(
                          checkInDate != null
                              ? '${checkInDate!.day}/${checkInDate!.month}/${checkInDate!.year}'
                              : 'Select Check-in',
                          style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 247, 247, 247)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );
                    if (picked != null && onCheckOutDateSelected != null) {
                      onCheckOutDateSelected!(picked);
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today,
                          color: const Color.fromARGB(255, 247, 248, 248)),
                      SizedBox(width: 8),
                      Center(
                        child: Text(
                          checkOutDate != null
                              ? '${checkOutDate!.day}/${checkOutDate!.month}/${checkOutDate!.year}'
                              : 'Select Check-out',
                          style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 247, 248, 248)),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class TotalPriceSection extends StatelessWidget {
  final double totalPrice;

  TotalPriceSection({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Total Price: \$${totalPrice.toStringAsFixed(2)}',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

class PaymentButton extends StatelessWidget {
  final void Function()? onPressed;

  PaymentButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: SizedBox(
        height: 45,
        width: double.infinity,
        child: Center(child: Text('Payment')),
      ),
    );
  }
}
