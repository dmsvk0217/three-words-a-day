class Verse {
  final int id;
  final int bookId;
  final int chapter;
  final int verse;
  final String text;

  Verse(
      {required this.id,
      required this.bookId,
      required this.chapter,
      required this.verse,
      required this.text});

  factory Verse.fromMap(Map<String, Object?> m) => Verse(
        id: m['id'] as int,
        bookId: m['book_id'] as int,
        chapter: m['chapter'] as int,
        verse: m['verse'] as int,
        text: m['text'] as String,
      );
}
