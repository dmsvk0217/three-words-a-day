import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../models/notification_setting.dart';

class LocalNotifier {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
  }

  static Future<void> scheduleDaily(NotificationTime t) async {
    final id = t.slot; // 1..3
    final time = tz.TZDateTime.now(tz.local)
        .copyWith(hour: t.hour, minute: t.minute, second: 0);
    final next = time.isBefore(tz.TZDateTime.now(tz.local))
        ? time.add(const Duration(days: 1))
        : time;

    await _plugin.zonedSchedule(
      id,
      '하루 세 말씀',
      '오늘의 말씀을 읽어볼까요?',
      next as tz.TZDateTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel',
          'Daily Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // 매일 반복
    );
  }

  static Future<void> cancelAll() => _plugin.cancelAll();

  static Future<void> reScheduleAll(List<NotificationTime> times) async {
    await cancelAll();
    for (final t in times) {
      if (t.enabled) {
        await scheduleDaily(t);
      }
    }
  }
}
