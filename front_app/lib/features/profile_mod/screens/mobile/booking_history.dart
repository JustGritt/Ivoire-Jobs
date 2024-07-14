import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:barassage_app/features/profile_mod/providers/bookings_provider.dart';
import 'package:barassage_app/features/profile_mod/widgets/booking_list_item.dart';

class BookingHistoryScreen extends StatelessWidget {
  final User user;
  const BookingHistoryScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingsProvider>(context, listen: false).fetchBookingsForCurrentUser();
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
