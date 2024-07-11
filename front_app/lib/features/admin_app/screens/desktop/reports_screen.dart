import 'package:barassage_app/features/admin_app/providers/reports_provider.dart';
import 'package:barassage_app/features/admin_app/widgets/report_card.dart';
import 'package:barassage_app/features/admin_app/models/report.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late Future<List<Report>> futureReports;

  @override
  void initState() {
    super.initState();
    final reportsProvider =
        Provider.of<ReportsProvider>(context, listen: false);
    futureReports = reportsProvider.getAllReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        //   icon: const Icon(Icons.arrow_back),
        // ),
      ),
      body: FutureBuilder<List<Report>>(
        future: futureReports,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text('No reports found.'));
          } else if (snapshot.hasData) {
            List<Report> reports = snapshot.data!;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total Reports: ${reports.length}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final report = reports[index];
                      return ReportCard(report: report);
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('No reports available.'));
        },
      ),
    );
  }
}

class ReportDetailScreen extends StatelessWidget {
  final Report report;

  const ReportDetailScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Text('Reported on ${DateFormat.yMMMd().format(report.createdAt)}'),
            const SizedBox(height: 16.0),
            Text(report.reason),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReportsProvider()),
      ],
      child: const MaterialApp(
        home: ReportScreen(),
      ),
    ),
  );
}
