import 'package:barassage_app/features/profile_mod/screens/mobile/booking_history.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SectionBookingsHistory extends StatelessWidget {
  final User user;
  const SectionBookingsHistory({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);

    return Container(
      width: width * 0.9,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.surface.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Booking History',
              style: theme.textTheme.displayLarge?.copyWith(fontSize: 20)),
          const SizedBox(height: 25),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookingHistoryScreen(user: user)),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(CupertinoIcons.app_badge),
                    const SizedBox(width: 20),
                    Text("My Bookings", style: theme.textTheme.labelMedium),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: theme.colorScheme.surface.withOpacity(0.3),
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(CupertinoIcons.mail),
                  const SizedBox(width: 20),
                  Text("Messages", style: theme.textTheme.labelMedium),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
