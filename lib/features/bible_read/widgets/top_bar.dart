import 'package:flutter/material.dart';

import 'drop_chip.dart';

class ReadTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String bookLabel;
  final String chapterLabel; // ex) "132편" or "3장"
  final VoidCallback onTapBook;
  final VoidCallback onTapChapter;

  const ReadTopBar({
    super.key,
    required this.bookLabel,
    required this.chapterLabel,
    required this.onTapBook,
    required this.onTapChapter,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF4A2F26),
      padding: const EdgeInsets.only(top: 8),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              const SizedBox(width: 12),
              const Icon(Icons.menu, color: Colors.white70),
              const Spacer(),
              DropChip(label: bookLabel, onTap: onTapBook),
              const SizedBox(width: 8),
              DropChip(label: chapterLabel, onTap: onTapChapter),
              const SizedBox(width: 8),
              const DropChip(label: '개역한글', enabled: false),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white70),
                onPressed: () {
                  // TODO: 검색 모달 연결 (필요 시)
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
