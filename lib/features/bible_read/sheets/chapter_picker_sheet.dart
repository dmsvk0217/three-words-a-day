import 'package:flutter/material.dart';

class ChapterPickerSheet extends StatelessWidget {
  final List<int> chapters;
  final int? selected;
  const ChapterPickerSheet({super.key, required this.chapters, this.selected});

  @override
  Widget build(BuildContext context) {
    return _BottomListFrame(
      title: '장 선택',
      child: ListView.builder(
        itemCount: chapters.length,
        itemBuilder: (_, i) {
          final c = chapters[i];
          final sel = selected == c;
          return ListTile(
            title: Text('$c 장'),
            trailing:
                sel ? const Icon(Icons.check, color: Colors.indigo) : null,
            onTap: () => Navigator.pop(context, c),
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
