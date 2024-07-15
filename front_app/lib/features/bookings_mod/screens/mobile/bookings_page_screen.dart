import 'package:barassage_app/features/bookings_mod/widgets/booking_service_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class BookingsPageScreen extends StatefulWidget {
  const BookingsPageScreen({super.key});

  @override
  State<BookingsPageScreen> createState() => _BookingsPageScreenState();
}

class _BookingsPageScreenState extends State<BookingsPageScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return CupertinoPageScaffold(
      // A ScrollView that creates custom scroll effects using slivers.
      child: CustomScrollView(
        // A list of sliver widgets.
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            brightness: Brightness.light,
            backgroundColor: theme.primaryColor.withOpacity(0.05),
            stretch: true,
            automaticallyImplyLeading: false,
            // This title is visible in both collapsed and expanded states.
            // When the "middle" parameter is omitted, the widget provided
            // in the "largeTitle" parameter is used instead in the collapsed state.
            largeTitle:
                Text('Bookings', style: TextStyle(color: theme.primaryColor)),
          ),
          SliverFillRemaining(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 10,
              padding: EdgeInsets.all(0),
              itemBuilder: (context, index) {
                return BookingServiceCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}
