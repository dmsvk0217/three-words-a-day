import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_words_a_day/core/db/db_helper.dart';

import 'app/app.dart';
import 'core/notifications/local_notifier.dart';
import 'core/notifications/tz_init.dart';
import 'core/repo/bible_repository.dart';
import 'core/repo/scrap_repository.dart';
import 'core/repo/settings_repository.dart';
import 'features/bible_read/controller.dart';
import 'features/scraps/controller.dart';
import 'features/settings/controller.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // DB 준비 (최초 실행 시 에셋 DB 복사)
    await AppDatabase.instance();

    // 로컬 알림/타임존 초기화(1회)
    await initTimeZonesSeoul();
    await LocalNotifier.init();

    runApp(const MyApp());
  }, (error, stack) {
    // 필요 시 로깅/크래시리포팅
    FlutterError.reportError(
        FlutterErrorDetails(exception: error, stack: stack));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Repositories
        Provider(create: (_) => BibleRepository()),
        Provider(create: (_) => ScrapRepository()),
        Provider(create: (_) => SettingsRepository()),
        // Controllers
        ChangeNotifierProvider(
          create: (ctx) => BibleReadController(
            bible: ctx.read<BibleRepository>(),
            scraps: ctx.read<ScrapRepository>(),
          )..init(), // 기본(창 1:1) 로드
        ),
        ChangeNotifierProvider(
          create: (ctx) =>
              ScrapsController(repo: ctx.read<ScrapRepository>())..refresh(),
        ),
        ChangeNotifierProvider(
          create: (ctx) =>
              SettingsController(repo: ctx.read<SettingsRepository>())..load(),
        ),
      ],
      child: MaterialApp(
        title: '하루 세 말씀',
        debugShowCheckedModeBanner: false,
        restorationScopeId: 'app', // 상태 복원(optional)
        theme: ThemeData(
          colorSchemeSeed: Colors.indigo,
          useMaterial3: true,
        ),
        home: const AppRoot(),
      ),
    );
  }
}
