class BookingStats {
  final int today;
  final int month;
  final int year;
  final int all;

  BookingStats({
    required this.today,
    required this.month,
    required this.year,
    required this.all,
  });

  factory BookingStats.fromJson(Map<String, dynamic> json) {
    return BookingStats(
      today: json['today'],
      month: json['month'],
      year: json['year'],
      all: json['all'],
    );
  }
}
