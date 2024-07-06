import 'package:flutter/material.dart';
import 'package:barassage_app/features/admin_app/models/report.dart';
import 'package:provider/provider.dart';
import 'package:barassage_app/features/admin_app/providers/reports_provider.dart';

class ReportDetailsScreen extends StatefulWidget {
  final Report report;
  const ReportDetailsScreen({super.key, required this.report});

  @override
  _ReportDetailsScreenState createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'ID: ${widget.report.id}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'User ID: ${widget.report.userId}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Service ID: ${widget.report.serviceId}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Reason: ${widget.report.reason}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${widget.report.createdAt}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Status: ${widget.report.status ? "Resolved" : "Pending"}',
              style: TextStyle(
                  fontSize: 16,
                  color: widget.report.status ? Colors.green : Colors.red),
            ),
            SizedBox(height: 16),
            Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    print('Removing report...');
                  },
                  child: Text('Remove'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Using Provider to access ReportProvider and validate the report
                    final reportProvider =
                        Provider.of<ReportsProvider>(context, listen: false);
                    reportProvider.updateReportStatus(widget.report).then((_) {
                      // After updating the report status, pop the current screen
                      Navigator.of(context).pop();
                    }).catchError((error) {
                      // Handle error if necessary
                      print('Error validating report: $error');
                    });
                    print('Validating report... ${widget.report.id}');
                  },
                  child: Text('Validate'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
