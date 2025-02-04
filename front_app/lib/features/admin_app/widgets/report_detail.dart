import 'package:barassage_app/features/admin_app/providers/reports_provider.dart';
import 'package:barassage_app/features/admin_app/utils/home_colors.dart';
import 'package:barassage_app/features/admin_app/models/report.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

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
        title: const Text('Report Details'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          color: Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: const Text('User ID'),
                  subtitle: Text(widget.report.userId.toString()),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Service ID'),
                  subtitle: Text(widget.report.serviceId.toString()),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Reason'),
                  subtitle: Text(widget.report.reason),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Date'),
                  subtitle: Text(widget.report.createdAt.toString()),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Status'),
                  subtitle: Text(
                    widget.report.status ? 'Resolved' : 'Pending',
                    style: TextStyle(
                      color: widget.report.status ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        final reportProvider = Provider.of<ReportsProvider>(
                            context,
                            listen: false);
                        reportProvider
                            .deleteReport(widget.report.id)
                            .then((_) {
                          Navigator.of(context).pop();
                        }).catchError((error) {
                          print('Error deleting report: $error');
                        });
                        print('Deleting report... ${widget.report.id}');
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        backgroundColor: Colors.redAccent,
                        shadowColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Remove'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        final reportProvider = Provider.of<ReportsProvider>(
                            context,
                            listen: false);
                        reportProvider
                            .updateReportStatus(widget.report)
                            .then((_) {
                          Navigator.of(context).pop();
                        }).catchError((error) {
                          print('Error validating report: $error');
                        });
                        print('Validating report... ${widget.report.id}');
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        backgroundColor: Colors.green,
                        shadowColor: Colors.green,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Validate'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
