import 'package:sqflite/sqflite.dart';

import '../db/db_helper.dart';
import '../models/scrap.dart';

class ScrapRepository {
  Future<Database> get _db async => AppDatabase.instance();

  Future<void> toggleScrap(
      {required int bookId, required int chapter, required int verse}) async {
    final db = await _db;
    final existing = await db.query('scraps',
        where: 'book_id=? AND chapter=? AND verse=?',
        whereArgs: [bookId, chapter, verse],
        limit: 1);
    if (existing.isEmpty) {
      await db.insert('scraps', {
        'book_id': bookId,
        'chapter': chapter,
        'verse': verse,
        'created_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      });
    } else {
      await db
          .delete('scraps', where: 'id=?', whereArgs: [existing.first['id']]);
    }
  }

  Future<List<Scrap>> listScraps() async {
    final db = await _db;
    final rows = await db.query('scraps', orderBy: 'created_at DESC');
    return rows.map((e) => Scrap.fromMap(e)).toList();
  }
}
