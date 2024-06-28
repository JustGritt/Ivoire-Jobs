extension StringExtension on String {
  String truncateTo(int maxLength) =>
      (this.length <= maxLength) ? this : '${this.substring(0, maxLength)}...';
}

extension StringDurationToTime on String {
  String get durationToTime {
    final duration = Duration(minutes: int.parse(this));
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours > 0 ? '$hours h' : ''} ${minutes > 0 ? '$minutes m' : ''}';
  }
}
