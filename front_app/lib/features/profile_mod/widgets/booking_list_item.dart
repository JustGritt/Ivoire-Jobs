import 'package:barassage_app/features/profile_mod/widgets/create_rating_dialog.dart';
import 'package:barassage_app/features/profile_mod/models/booking.dart';
import 'package:flutter/material.dart';

class BookingListItem extends StatelessWidget {
  final Booking booking;
  const BookingListItem({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.grey[200],
      child: InkWell(
        onTap: () {
          showRatingDialog(context, booking);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Service ID: ${booking.serviceId}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    'Start: ${booking.startTime}',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    'End: ${booking.endTime}',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    booking.status == 'completed'
                        ? Icons.check_circle
                        : Icons.error,
                    color: booking.status == 'completed'
                        ? Colors.green
                        : Colors.red,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Status: ${booking.status}',
                    style: TextStyle(
                      color: booking.status == 'completed'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
