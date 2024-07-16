import 'package:barassage_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:barassage_app/features/bookings_mod/screens/screen.dart'
    as mobile;

class BookingsController extends StatelessController {
  const BookingsController({super.key});

  @override
  bool get auth => true;

  @override
  Display view(BuildContext context) {
    return Display(
      title: 'Bookings Area',
      mobile: const mobile.BookingsPageScreen(),
    );
  }
}
