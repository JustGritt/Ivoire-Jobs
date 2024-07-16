import 'package:barassage_app/features/admin_app/providers/reports_provider.dart';
import 'package:barassage_app/features/admin_app/widgets/report_card.dart';
import 'package:barassage_app/features/admin_app/models/report.dart';
import 'package:barassage_app/features/admin_app/widgets/report_search_input.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:barassage_app/features/admin_app/utils/home_colors.dart';


class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late Future<List<Report>> futureReports;
  final TextEditingController _searchController = TextEditingController();
  List<Report> _filteredReports = [];

  @override
  void initState() {
    super.initState();
    final reportsProvider = Provider.of<ReportsProvider>(context, listen: false);
    futureReports = reportsProvider.getAllReports();
    futureReports.then((reports) {
      setState(() {
        _filteredReports = reports;
      });
    });
  }

  void _handleSearch(String query) {
    futureReports.then((reports) {
      final filtered = reports.where((report) {
        final reportTitle = report.reason.toLowerCase();
        final searchQuery = query.toLowerCase();
        return reportTitle.contains(searchQuery);
      }).toList();
      setState(() {
        _filteredReports = filtered;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Number of reports: ${_filteredReports.length}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primary,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.refresh, color: primary),
                            onPressed: () {
                              futureReports = Provider.of<ReportsProvider>(context, listen: false).getAllReports();
                              futureReports.then((reports) {
                                setState(() {
                                  _filteredReports = reports;
                                });
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ReportSearchInput(
                        textController: _searchController,
                        hintText: 'Search Reports',
                        onChanged: _handleSearch,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredReports.length,
                    itemBuilder: (context, index) {
                      final report = _filteredReports[index];
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
