import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/admin_app/models/log.dart';
import 'package:barassage_app/features/admin_app/services/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/logs_provider.dart';

AdminService adminService = serviceLocator<AdminService>();

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  late Future<void> logsFuture;

  @override
  void initState() {
    super.initState();
    logsFuture = fetchLogs();
  }

  Future<void> fetchLogs() async {
    final logsProvider = Provider.of<LogsProvider>(context, listen: false);
    await logsProvider.getAllLogs();
  }

  Widget _buildLevelChip(String level) {
    Color backgroundColor;
    String text;

    switch (level.toLowerCase()) {
      case 'info':
        backgroundColor = Colors.blue.shade100;
        text = 'INFO';
        break;
      case 'warn':
        backgroundColor = Colors.yellow.shade100;
        text = 'WARN';
        break;
      case 'error':
        backgroundColor = Colors.red.shade100;
        text = 'ERROR';
        break;
      default:
        backgroundColor = Colors.grey.shade200;
        text = level.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: FutureBuilder<void>(
        future: logsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading logs'));
          } else {
            return Consumer<LogsProvider>(
              builder: (context, logsProvider, child) {
                if (logsProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (logsProvider.logs.isEmpty) {
                  return Center(child: Text('No logs available'));
                } else {
                  return Container(
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              child: DataTable(
                                columnSpacing: 12.0,
                                headingRowHeight: 56.0,
                                dataRowHeight: 56.0,
                                dividerThickness: 0.5,
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      'Level',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Type',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Message',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: logsProvider.logs
                                    .map(
                                      (log) => DataRow(
                                    cells: [
                                      DataCell(_buildLevelChip(log.level)),
                                      DataCell(Text(log.type)),
                                      DataCell(
                                        Tooltip(
                                          message: log.message,
                                          child: Text(
                                            log.message
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                    .toList(),
                                headingRowColor: MaterialStateProperty.all(theme.primaryColor.withOpacity(0.1)),
                                dataRowColor: MaterialStateProperty.all(Colors.white),
                                horizontalMargin: 12,
                                headingTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                                border: TableBorder(
                                  horizontalInside: BorderSide(
                                    color: Colors.grey.shade100,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: logsProvider.currentPage > 1
                                    ? () {
                                  logsProvider.previousPage();
                                }
                                    : null,
                              ),
                              Text(
                                  '${logsProvider.currentPage} / ${logsProvider.totalPages}'),
                              IconButton(
                                icon: Icon(Icons.arrow_forward),
                                onPressed: logsProvider.currentPage <
                                    logsProvider.totalPages
                                    ? () {
                                  logsProvider.nextPage();
                                }
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
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