import 'package:flutter/material.dart';

import '../../core/models/notification_setting.dart';
import '../../core/notifications/local_notifier.dart';
import '../../core/notifications/tz_init.dart';
import '../../core/repo/settings_repository.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final repo = SettingsRepository();
  List<NotificationTime> times = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await initTimeZonesSeoul();
    await LocalNotifier.init();
    times = await repo.loadTimes();
    if (mounted) setState(() {});
  }

  Future<void> _pickTime(NotificationTime t) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: t.hour, minute: t.minute),
    );
    if (picked != null) {
      final updated = NotificationTime(
          slot: t.slot,
          hour: picked.hour,
          minute: picked.minute,
          enabled: t.enabled);
      await repo.saveTime(updated);
      await _refresh();
    }
  }

  Future<void> _toggle(NotificationTime t, bool val) async {
    final updated = NotificationTime(
        slot: t.slot, hour: t.hour, minute: t.minute, enabled: val);
    await repo.saveTime(updated);
    await _refresh();
  }

  Future<void> _refresh() async {
    times = await repo.loadTimes();
    await LocalNotifier.reScheduleAll(times);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        children: [
          const ListTile(title: Text('알림 시간(최대 3개)')),
          ...times.map((t) => SwitchListTile(
                title: Text(
                    '알림 ${t.slot}: ${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}'),
                value: t.enabled,
                onChanged: (v) => _toggle(t, v),
                secondary: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () => _pickTime(t)),
              )),
          const Divider(),
          const ListTile(
            title: Text('서비스 소개'),
            subtitle: Text('하루 세 말씀: 하루에 세 번, 말씀과 가까워지는 습관을 도와드려요.'),
          ),
          const AboutListTile(
            icon: Icon(Icons.info_outline),
            applicationName: '하루 세 말씀',
            applicationVersion: '0.1.0',
            applicationLegalese: '개역한글 본문은 퍼블릭 도메인 텍스트를 사용합니다.',
          ),
        ],
      ),
    );
  }
}
