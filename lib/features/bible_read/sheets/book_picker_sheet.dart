import 'package:flutter/material.dart';

import '../../../core/models/book.dart';

class BookPickerSheet extends StatelessWidget {
  final List<Book> books;
  final int? selectedBookId;
  const BookPickerSheet({super.key, required this.books, this.selectedBookId});

  @override
  Widget build(BuildContext context) {
    return _BottomListFrame(
      title: '책 선택',
      child: ListView.builder(
        itemCount: books.length,
        itemBuilder: (_, i) {
          final b = books[i];
          final sel = selectedBookId == b.id;
          return ListTile(
            title: Text(b.name),
            trailing:
                sel ? const Icon(Icons.check, color: Colors.indigo) : null,
            onTap: () => Navigator.pop(context, b.id),
          );
        },
      ),
    );
  }
}

class _BottomListFrame extends StatelessWidget {
  final String title;
  final Widget child;
  const _BottomListFrame({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (ctx, scroll) => Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(2.5))),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const Spacer(),
                  IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
