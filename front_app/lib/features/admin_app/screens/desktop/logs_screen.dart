import 'package:barassage_app/features/admin_app/providers/logs_provider.dart';
import 'package:barassage_app/features/admin_app/services/admin_service.dart';
import 'package:barassage_app/features/admin_app/utils/home_colors.dart';
import 'package:barassage_app/features/admin_app/widgets/tag_filter.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/log.dart';

AdminService adminService = serviceLocator<AdminService>();

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  late Future<void> logsFuture;
  String selectedLevel = 'All';
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    logsFuture = fetchLogs();
  }

  Future<void> fetchLogs() async {
    final logsProvider = Provider.of<LogsProvider>(context, listen: false);
    await logsProvider.getAllLogs();
  }

  String formatDate(DateTime date) {
    return DateFormat.yMMMd().add_jm().format(date);
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
      body: Column(
        children: [
          TagFilterSection(
            selectedLevel: selectedLevel,
            startDate: startDate,
            endDate: endDate,
            onLevelChanged: (String? newValue) {
              setState(() {
                selectedLevel = newValue!;
              });
            },
            onDateRangeSelected: () => _selectDateRange(context),
          ),
          Expanded(
            child: FutureBuilder<void>(
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
                      } else if (logsProvider.logs.items.isEmpty) {
                        return Center(child: Text('No logs available'));
                      } else {
                        List<Log> filteredLogs = logsProvider.logs.items.where((log) {
                          bool levelMatch = selectedLevel == 'All' ||
                              log.level.toLowerCase() == selectedLevel.toLowerCase();
                          bool dateMatch = true;
                          if (startDate != null && endDate != null) {
                            DateTime logDate = DateTime.parse(log.createdAt);
                            dateMatch = logDate.isAfter(startDate!) && logDate.isBefore(endDate!);
                          }
                          return levelMatch && dateMatch;
                        }).toList();
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
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
                                  DataColumn(
                                    label: Text(
                                      'Created At',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: filteredLogs.map((log) => DataRow(
                                  cells: [
                                    DataCell(_buildLevelChip(log.level)),
                                    DataCell(Text(log.type)),
                                    DataCell(
                                      Tooltip(
                                        message: log.message,
                                        child: Text(
                                          log.message.length > 50
                                              ? log.message.substring(0, 50) + '...'
                                              : log.message,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(formatDate(DateTime.parse(log.createdAt))),
                                    ),
                                  ],
                                )).toList(),
                                headingRowColor: MaterialStateProperty.all(
                                    theme.primaryColor.withOpacity(0.1)),
                                dataRowColor:
                                MaterialStateProperty.all(Colors.white),
                                horizontalMargin: 12,
                                headingTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                                border: TableBorder(
                                  horizontalInside: BorderSide(
                                    color: Colors.grey.shade300, // Light gray line
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Consumer<LogsProvider>(
              builder: (context, logsProvider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!logsProvider.logs.first)
                      IconButton(
                        icon: Icon(Icons.first_page, color: theme.primaryColor),
                        onPressed: () {
                          logsProvider.jumpToPage(1);
                        },
                      ),
                    if (!logsProvider.logs.first)
                      IconButton(
                        icon: Icon(Icons.chevron_left, color: theme.primaryColor),
                        onPressed: () {
                          logsProvider.previousPage();
                        },
                      ),
                    Text(
                        '${logsProvider.logs.currentPage} / ${logsProvider.logs.totalPages}'),
                    if (!logsProvider.logs.last)
                      IconButton(
                        icon: Icon(Icons.chevron_right, color: theme.primaryColor),
                        onPressed: () {
                          logsProvider.nextPage();
                        },
                      ),
                    if (!logsProvider.logs.last)
                      IconButton(
                        icon: Icon(Icons.last_page, color: theme.primaryColor),
                        onPressed: () {
                          logsProvider.jumpToPage(logsProvider.logs.totalPages);
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}