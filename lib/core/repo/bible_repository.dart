import 'package:sqflite/sqflite.dart';

import '../db/db_helper.dart';
import '../models/book.dart';
import '../models/verse.dart';

class BibleRepository {
  Future<Database> get _db async => AppDatabase.instance();

  Future<List<Book>> fetchBooks() async {
    final db = await _db;
    final rows = await db.query('books', orderBy: 'id ASC');
    return rows.map((e) => Book.fromMap(e)).toList();
  }

  Future<List<int>> fetchChapters(int bookId) async {
    final db = await _db;
    // chapters 테이블이 없을 수도 있으니 verses 집계로 보장
    final rows = await db.rawQuery(
      'SELECT chapter, COUNT(1) as c FROM verses WHERE book_id=? GROUP BY chapter ORDER BY chapter',
      [bookId],
    );
    return rows.map((e) => e['chapter'] as int).toList();
  }

  Future<List<Verse>> fetchVerses(int bookId, int chapter) async {
    final db = await _db;
    final rows = await db.query(
      'verses',
      where: 'book_id=? AND chapter=?',
      whereArgs: [bookId, chapter],
      orderBy: 'verse ASC',
    );
    return rows.map((e) => Verse.fromMap(e)).toList();
  }

  Future<List<Verse>> search(String keyword, {int limit = 50}) async {
    final db = await _db;
    final rows = await db.query(
      'verses',
      where: 'text LIKE ?',
      whereArgs: ['%$keyword%'],
      orderBy: 'book_id, chapter, verse',
      limit: limit,
    );
    return rows.map((e) => Verse.fromMap(e)).toList();
  }
}
