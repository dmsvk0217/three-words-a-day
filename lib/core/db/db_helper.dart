import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? _db;
  static const _dbName = 'bible_krv.sqlite';
  static const _assetDbPath = 'assets/db/bible_krv.sqlite';

  static Future<Database> instance() async {
    if (_db != null) return _db!;
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dir.path, _dbName);

    // 1) 파일 없거나 0바이트/손상 → 에셋에서 다시 복사
    if (!await File(dbPath).exists() || (await File(dbPath).length()) < 1024) {
      await _copyFromAsset(dbPath);
    }

    _db = await openDatabase(
      dbPath,
      version: 1,
      onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON;'),
      onOpen: (db) async {
        // 2) 핵심 테이블 존재 확인, 없으면 재복사(또는 스키마 생성)
        final ok = await _hasCoreTables(db);
        if (!ok) {
          await db.close();
          await _copyFromAsset(dbPath);
          _db = await openDatabase(
            dbPath,
            version: 1,
            onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON;'),
          );
        }
      },
    );
    return _db!;
  }

  static Future<void> _copyFromAsset(String targetPath) async {
    final bytes = (await rootBundle.load(_assetDbPath)).buffer.asUint8List();
    await File(targetPath).writeAsBytes(bytes, flush: true);
  }

  static Future<bool> _hasCoreTables(Database db) async {
    try {
      final tables = await db
          .rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
      final names = tables.map((e) => (e['name'] ?? '') as String).toSet();
      // 앱이 기대하는 핵심 테이블
      return names.contains('verses') &&
          names.contains('books') &&
          names.contains('scraps') &&
          names.contains('notification_times');
    } catch (_) {
      return false;
    }
  }
}
