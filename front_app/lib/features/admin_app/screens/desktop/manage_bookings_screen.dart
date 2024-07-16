import 'package:barassage_app/features/admin_app/providers/bookings_provider.dart';
import 'package:barassage_app/features/admin_app/widgets/booking_filter.dart';
import 'package:barassage_app/features/admin_app/services/admin_service.dart';
import 'package:barassage_app/features/admin_app/widgets/booking_card.dart';
import 'package:barassage_app/features/admin_app/utils/home_colors.dart';
import 'package:barassage_app/features/admin_app/models/booking.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

AdminService adminService = serviceLocator<AdminService>();

class ManageBookingsScreen extends StatefulWidget {
  const ManageBookingsScreen({super.key});

  @override
  State<ManageBookingsScreen> createState() => _ManageBookingsScreenState();
}

class _ManageBookingsScreenState extends State<ManageBookingsScreen> {
  late Future<List<Booking>> bookingsFuture;
  String selectedStatus = 'All';
  DateTime? startDate;
  DateTime? endDate;

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

  void _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primary,
              onSurface: primary,
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null &&
        picked !=
            DateTimeRange(
                start: startDate ?? DateTime.now(),
                end: endDate ?? DateTime.now())) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          BookingFilterSection(
            selectedStatus: selectedStatus,
            startDate: startDate,
            endDate: endDate,
            onStatusChanged: (String? newValue) {
              setState(() {
                selectedStatus = newValue!;
              });
            },
            onDateRangeSelected: () => _selectDateRange(context),
          ),
          Expanded(
            child: FutureBuilder<List<Booking>>(
              future: bookingsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  debugPrint(snapshot.error.toString());
                  return Center(child: Text('Error loading bookings'));
                } else {
                  return Consumer<BookingsProvider>(
                    builder: (context, bookingsProvider, child) {
                      if (bookingsProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (bookingsProvider.bookings.isEmpty) {
                        return const Center(
                            child: Text('No bookings available'));
                      } else {
                        List<Booking> filteredBookings =
                            bookingsProvider.bookings.where((booking) {
                          bool statusMatch = selectedStatus == 'All' ||
                              booking.status == selectedStatus;
                          bool dateMatch = true;
                          if (startDate != null && endDate != null) {
                            dateMatch = booking.startTime.isAfter(startDate!) &&
                                booking.endTime.isBefore(endDate!);
                          }
                          return statusMatch && dateMatch;
                        }).toList();
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 2 / 1,
                            ),
                            itemCount: filteredBookings.length,
                            itemBuilder: (context, index) {
                              final booking = filteredBookings[index];
                              return BookingCard(booking: booking);
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
