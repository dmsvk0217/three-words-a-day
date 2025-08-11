import 'package:flutter/foundation.dart';

import '../../core/models/notification_setting.dart';
import '../../core/notifications/local_notifier.dart';
import '../../core/repo/settings_repository.dart';

class SettingsController extends ChangeNotifier {
  final SettingsRepository repo;
  SettingsController({required this.repo});

  List<NotificationTime> _times = [];
  List<NotificationTime> get times => _times;

  Future<void> load() async {
    _times = await repo.loadTimes();
    notifyListeners();
  }

  Future<void> setTime(NotificationTime t) async {
    await repo.saveTime(t);
    _times = await repo.loadTimes();
    await LocalNotifier.reScheduleAll(_times);
    notifyListeners();
  }

  Future<void> toggle(int slot, bool enabled) async {
    final t = _times.firstWhere((e) => e.slot == slot);
    await setTime(NotificationTime(
        slot: slot, hour: t.hour, minute: t.minute, enabled: enabled));
  }
}
