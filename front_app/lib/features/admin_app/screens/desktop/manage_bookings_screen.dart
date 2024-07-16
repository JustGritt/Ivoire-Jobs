import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/admin_app/providers/bookings_provider.dart';
import 'package:barassage_app/features/admin_app/services/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/booking.dart';

AdminService adminService = serviceLocator<AdminService>();

class ManageBookingsScreen extends StatefulWidget {
  const ManageBookingsScreen({super.key});

  @override
  State<ManageBookingsScreen> createState() => _ManageBookingsScreenState();
}

class _ManageBookingsScreenState extends State<ManageBookingsScreen> {
  late Future<List<Booking>> bookingsFuture;
  String selectedStatus = 'All';

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

  String formatDate(DateTime date) {
    return DateFormat.yMMMd().add_jm().format(date);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Filter by status: '),
                  DropdownButton<String>(
                    value: selectedStatus,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStatus = newValue!;
                      });
                    },
                    items: <String>['All', 'created', 'fulfilled', 'cancelled']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Booking>>(
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
                        List<Booking> filteredBookings = selectedStatus == 'All'
                            ? bookingsProvider.bookings
                            : bookingsProvider.bookings
                            .where((booking) =>
                        booking.status == selectedStatus)
                            .toList();
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GridView.builder(
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 3,
                            ),
                            itemCount: filteredBookings.length,
                            itemBuilder: (context, index) {
                              final booking = filteredBookings[index];
                              return Card(
                                color: Colors.white,
                                margin:
                                const EdgeInsets.symmetric(vertical: 8.0),
                                elevation: 4,
                                shadowColor: Colors.grey.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: theme.primaryColor
                                                  .withOpacity(0.1),
                                              borderRadius:
                                              BorderRadius.circular(5),
                                            ),
                                            child: Icon(
                                              Icons.calendar_month,
                                              color: theme.primaryColor,
                                              size: 20,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              formatDate(booking.startTime),
                                              style: theme.textTheme.bodyLarge
                                                  ?.copyWith(fontSize: 16),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'End: ${formatDate(booking.endTime)}',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(fontSize: 14),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Contact: ${booking.contact.firstName} ${booking.contact.lastName}',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(fontSize: 14),
                                      ),
                                      Text(
                                        'Service: ${booking.service.title}',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(fontSize: 14),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'Status: ${booking.status}',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          fontSize: 14,
                                          color: booking.status == 'fulfilled'
                                              ? Colors.green
                                              : booking.status == 'cancelled'
                                              ? Colors.red
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
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
          ),
        ],
      ),
    );
  }
}