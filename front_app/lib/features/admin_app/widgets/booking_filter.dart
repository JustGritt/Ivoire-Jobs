import 'package:barassage_app/features/admin_app/utils/home_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingFilterSection extends StatelessWidget {
  final String selectedStatus;
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<String?> onStatusChanged;
  final VoidCallback onDateRangeSelected;

  const BookingFilterSection({
    required this.selectedStatus,
    required this.startDate,
    required this.endDate,
    required this.onStatusChanged,
    required this.onDateRangeSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Manage Bookings',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: primary, width: 2.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedStatus,
                    onChanged: onStatusChanged,
                    items: <String>['All', 'created', 'fulfilled', 'cancelled']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(fontSize: 16, color: primary),
                        ),
                      );
                    }).toList(),
                    icon: Icon(Icons.arrow_drop_down, color: primary),
                    dropdownColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: onDateRangeSelected,
                icon: const Icon(Icons.date_range, color: Colors.white),
                label: Text(
                  startDate == null && endDate == null
                      ? 'Select Date Range'
                      : '${DateFormat.yMMMd().format(startDate!)} - ${DateFormat.yMMMd().format(endDate!)}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
