class NotificationTime {
  final int slot; // 1..3
  final int hour; // 0..23
  final int minute; // 0..59
  final bool enabled;

  NotificationTime(
      {required this.slot,
      required this.hour,
      required this.minute,
      required this.enabled});
}
