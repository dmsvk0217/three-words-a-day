import 'package:flutter/foundation.dart';

import '../../core/models/book.dart';
import '../../core/models/verse.dart';
import '../../core/repo/bible_repository.dart';
import '../../core/repo/scrap_repository.dart';

class BibleReadController extends ChangeNotifier {
  final BibleRepository bible;
  final ScrapRepository scraps;

  List<Book> _books = [];
  int _bookId;
  int _chapter;
  bool _loading = true;
  List<Verse> _verses = [];

  BibleReadController({
    required this.bible,
    required this.scraps,
    int initialBookId = 1,
    int initialChapter = 1,
  })  : _bookId = initialBookId,
        _chapter = initialChapter;

  List<Book> get books => _books;
  int get bookId => _bookId;
  int get chapter => _chapter;
  bool get loading => _loading;
  List<Verse> get verses => _verses;
  String get bookAbbr => _books
      .firstWhere((b) => b.id == _bookId,
          orElse: () => Book(id: _bookId, name: '책', abbr: ''))
      .abbr;

  Future<void> init() async {
    _books = await bible.fetchBooks();
    if (_books.isEmpty) {
      _loading = false;
      notifyListeners();
      return;
    }
    if (!_books.any((b) => b.id == _bookId)) {
      _bookId = _books.first.id;
    }
    await _load();
  }

  Future<void> _load() async {
    _loading = true;
    notifyListeners();
    _verses = await bible.fetchVerses(_bookId, _chapter);
    _loading = false;
    notifyListeners();
  }

  String get bookName => _books
      .firstWhere((b) => b.id == _bookId,
          orElse: () => Book(id: _bookId, name: '책', abbr: ''))
      .name;

  Future<List<int>> chaptersOf(int bookId) => bible.fetchChapters(bookId);

  Future<void> selectBookAndChapter(
      {required int newBookId, required int newChapter}) async {
    _bookId = newBookId;
    _chapter = newChapter;
    await _load();
  }

  Future<void> selectChapterOnly(int newChapter) async {
    _chapter = newChapter;
    await _load();
  }

  Future<void> toggleScrap(Verse v) async {
    await scraps.toggleScrap(
        bookId: v.bookId, chapter: v.chapter, verse: v.verse);
  }

  Future<bool> isScrapped(Verse verse) async {
    return await scraps.exists(
      bookId: verse.bookId,
      chapter: verse.chapter,
      verse: verse.verse,
    );
  }
}
