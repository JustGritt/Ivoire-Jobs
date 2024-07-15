import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/admin_app/models/booking.dart';
import 'package:barassage_app/features/admin_app/providers/bookings_provider.dart';
import 'package:barassage_app/features/admin_app/services/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

AdminService adminService = serviceLocator<AdminService>();

class ManageBookingsScreen extends StatefulWidget {
  const ManageBookingsScreen({super.key});

  @override
  State<ManageBookingsScreen> createState() => _ManageBookingsScreenState();
}

class _ManageBookingsScreenState extends State<ManageBookingsScreen> {
  late Future<List<Booking>> bookingsFuture;

  @override
  void initState() {
    super.initState();
    bookingsFuture = fetchBookings();
  }

  Future<List<Booking>> fetchBookings() async {
    final bookingsProvider =
    Provider.of<BookingsProvider>(context, listen: false);
    await bookingsProvider.getBookings();
    return bookingsProvider.bookings;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Bookings',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<void>(
        future: bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading bookings'));
          } else {
            return Consumer<BookingsProvider>(
              builder: (context, bookingsProvider, child) {
                if (bookingsProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (bookingsProvider.bookings.isEmpty) {
                  return Center(child: Text('No bookings available'));
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        childAspectRatio: 2 / 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: bookingsProvider.bookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookingsProvider.bookings[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    color: theme.primaryColor,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      booking.startTime.toString(),
                                      style: theme.textTheme.bodyLarge?.copyWith(fontSize: 24),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Text(
                                booking.endTime.toString(),
                                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 18),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
