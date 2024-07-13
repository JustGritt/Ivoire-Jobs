import 'package:flutter/material.dart';
import 'package:barassage_app/features/admin_app/utils/home_colors.dart';
import 'package:barassage_app/features/admin_app/models/dashboard_stats.dart';
import 'package:barassage_app/features/admin_app/services/admin_service.dart';
import 'package:barassage_app/features/admin_app/widgets/stats_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<DashboardStats> futureStats;
  DashboardStats? stats;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getDashboardStats();
  }

  void getDashboardStats() async {
    setState(() {
      isLoading = true;
    });

    try {
      AdminService as = AdminService();
      var fetchedStats = await as.fetchDashboardStats();
      setState(() {
        stats = fetchedStats;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error: $e');
      setState(() {
        stats = null;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : stats == null
          ? const Center(child: Text('Failed to load data'))
          : Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: getDashboardStats,
                ),
              ],
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount;
                  if (constraints.maxWidth >= 1200) {
                    crossAxisCount = 6;
                  } else if (constraints.maxWidth >= 800) {
                    crossAxisCount = 3;
                  } else {
                    crossAxisCount = 2;
                  }
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      StatsCard(
                        title: 'Total Users',
                        icon: Icons.people,
                        color: primary,
                        info: stats!.totalUsers.toString(),
                      ),
                      StatsCard(
                        title: 'Total Members',
                        icon: Icons.group,
                        color: primary,
                        info: stats!.totalMembers.toString(),
                      ),
                      StatsCard(
                        title: 'Current Live Users',
                        icon: Icons.person,
                        color: primary,
                        info: stats!.totalLiveUsers.toString(),
                      ),
                      StatsCard(
                        title: 'Total Services',
                        icon: Icons.build,
                        color: primary,
                        info: stats!.totalServices.toString(),
                      ),
                      StatsCard(
                        title: 'Bookings Today',
                        icon: Icons.today,
                        color: primary,
                        info: stats!.bookings.today.toString(),
                      ),
                      StatsCard(
                        title: 'Bookings This Month',
                        icon: Icons.calendar_today,
                        color: primary,
                        info: stats!.bookings.month.toString(),
                      ),
                      StatsCard(
                        title: 'Bookings This Year',
                        icon: Icons.date_range,
                        color: primary,
                        info: stats!.bookings.year.toString(),
                      ),
                      StatsCard(
                        title: 'Total Bookings',
                        icon: Icons.event,
                        color: primary,
                        info: stats!.bookings.all.toString(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
