import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceBookingScreen extends StatefulWidget {
  const ServiceBookingScreen({super.key});

  @override
  State<ServiceBookingScreen> createState() => _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends State<ServiceBookingScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Text(
          'Service Booking',
          style: theme.textTheme.labelMedium,
        ),
        leading: IconButton(
            icon: Icon(CupertinoIcons.back, color: theme.primaryColorDark),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: const Center(
        child: Text('Service Booking'),
      ),
    );
  }
}
