class Book {
  final int id;
  final String name;
  final String abbr;

  Book({required this.id, required this.name, required this.abbr});

  factory Book.fromMap(Map<String, Object?> m) => Book(
      id: m['id'] as int, name: m['name'] as String, abbr: m['abbr'] as String);
}
