class Scrap {
  final int id;
  final int bookId;
  final int chapter;
  final int verse;
  final String? note;
  final DateTime createdAt;

  Scrap(
      {required this.id,
      required this.bookId,
      required this.chapter,
      required this.verse,
      this.note,
      required this.createdAt});

  factory Scrap.fromMap(Map<String, Object?> m) => Scrap(
        id: m['id'] as int,
        bookId: m['book_id'] as int,
        chapter: m['chapter'] as int,
        verse: m['verse'] as int,
        note: m['note'] as String?,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
            (m['created_at'] as int) * 1000),
      );
}
