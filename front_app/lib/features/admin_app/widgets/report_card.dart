import 'package:barassage_app/features/admin_app/models/report.dart';
import 'package:barassage_app/features/admin_app/widgets/report_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportCard extends StatelessWidget {
  final Report report;
  const ReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ReportDetailsScreen(report: report),
          ),
        );
      },
      child: Card(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reason: ${report.reason} - ${DateFormat.yMMMd().format(report.createdAt)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('User ID: ${report.userId}'),
              SizedBox(height: 4),
              Text('Service ID: ${report.serviceId}'),
            ],
          ),
        ),
      ),
    );
  }
}