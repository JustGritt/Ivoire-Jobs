import 'package:barassage_app/features/admin_app/screens/desktop/manage_bookings_screen.dart';
import 'package:flutter/material.dart';
import 'package:barassage_app/features/admin_app/widgets/admin_menu.dart';


class BookingsController extends StatelessWidget {
  const BookingsController({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      color: Colors.blue,
      child: AdminScaffold(
        title: 'Bookings',
        body: const ManageBookingsScreen(),
      ),
    );
  }
}
