import 'package:barassage_app/features/admin_app/models/booking_stats.dart';

class DashboardStats {
  final int totalUsers;
  final int totalMembers;
  final int totalLiveUsers;
  final int totalServices;
  final BookingStats bookings;

  DashboardStats({
    required this.totalUsers,
    required this.totalMembers,
    required this.totalLiveUsers,
    required this.totalServices,
    required this.bookings,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalUsers: json['totalUsers'],
      totalMembers: json['totalMembers'],
      totalLiveUsers: json['totalLiveUsers'],
      totalServices: json['totalServices'],
      bookings: BookingStats.fromJson(json['bookings']),
    );
  }
}
