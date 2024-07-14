import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:barassage_app/features/profile_mod/providers/bookings_provider.dart';
import 'package:barassage_app/features/profile_mod/models/booking.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingHistoryScreen extends StatelessWidget {
  final User user;
  const BookingHistoryScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingsProvider>(context, listen: false).GetBookings();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking History'),
      ),
      body: Consumer<BookingsProvider>(
        builder: (context, bookingsProvider, child) {
          if (bookingsProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (bookingsProvider.bookings.isEmpty) {
            return Center(child: Text('No bookings found'));
          }

          return ListView.builder(
            itemCount: bookingsProvider.bookings.length,
            itemBuilder: (context, index) {
              final booking = bookingsProvider.bookings[index];
              return BookingListItem(booking: booking);
            },
          );
        },
      ),
    );
  }
}

class BookingListItem extends StatelessWidget {
  final Booking booking;

  const BookingListItem({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Service ID: ${booking.serviceId}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Start: ${booking.startTime}'),
          Text('End: ${booking.endTime}'),
          Text('Status: ${booking.status}'),
        ],
      ),
      isThreeLine: true,
    );
  }
}
