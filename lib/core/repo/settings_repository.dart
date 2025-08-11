import 'package:sqflite/sqflite.dart';

import '../db/db_helper.dart';
import '../models/notification_setting.dart';

class SettingsRepository {
  Future<Database> get _db async => AppDatabase.instance();

  Future<List<NotificationTime>> loadTimes() async {
    final db = await _db;
    final rows = await db.query('notification_times', orderBy: 'id');
    if (rows.isEmpty) {
      // 초기 3슬롯 생성 (오전 8시, 정오, 오후 9시)
      await db.insert('notification_times',
          {'id': 1, 'hour': 8, 'minute': 0, 'enabled': 1});
      await db.insert('notification_times',
          {'id': 2, 'hour': 12, 'minute': 0, 'enabled': 1});
      await db.insert('notification_times',
          {'id': 3, 'hour': 21, 'minute': 0, 'enabled': 1});
      return loadTimes();
    }
    return rows
        .map((e) => NotificationTime(
              slot: e['id'] as int,
              hour: e['hour'] as int,
              minute: e['minute'] as int,
              enabled: (e['enabled'] as int) == 1,
            ))
        .toList();
  }

  Future<void> saveTime(NotificationTime t) async {
    final db = await _db;
    await db.update('notification_times',
        {'hour': t.hour, 'minute': t.minute, 'enabled': t.enabled ? 1 : 0},
        where: 'id=?', whereArgs: [t.slot]);
  }
}
