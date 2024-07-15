import 'package:flutter/material.dart';

class BookingServiceCard extends StatefulWidget {
  const BookingServiceCard({super.key});

  @override
  State<BookingServiceCard> createState() => _BookingServiceCardState();
}

class _BookingServiceCardState extends State<BookingServiceCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Text('BookingService'),
    );
  }
}