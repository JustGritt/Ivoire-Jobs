import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../screens/screen.dart' as mobile;

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
