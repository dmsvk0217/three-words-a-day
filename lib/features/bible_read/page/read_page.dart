import 'package:flutter/material.dart';

import '../../../core/models/verse.dart';
import '../../../core/repo/bible_repository.dart';
import '../../../core/repo/scrap_repository.dart';
import '../controller.dart';
import '../sheets/book_picker_sheet.dart';
import '../sheets/chapter_picker_sheet.dart';
import '../widgets/top_bar.dart';
import '../widgets/verse_tile.dart';

class ReadPage extends StatefulWidget {
  const ReadPage({super.key});
  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  late final BibleReadController controller;

  @override
  void initState() {
    super.initState();
    controller = BibleReadController(
      bible: BibleRepository(),
      scraps: ScrapRepository(),
    );
    controller.addListener(_onControllerChanged);
    controller.init();
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerChanged);
    controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() => setState(() {});

  // 시편이면 '편', 그 외엔 '장'
  String _formatChapterLabel(String bookName, int chapter) {
    final isPsalms = bookName == '시편';
    return '$chapter${isPsalms ? '편' : '장'}';
  }

  Future<void> _pickBookThenChapter() async {
    if (controller.books.isEmpty) return;

    // 1) 책 선택
    final selectedBookId = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BookPickerSheet(
        books: controller.books,
        selectedBookId: controller.bookId,
      ),
    );
    if (selectedBookId == null) return;

    // 2) 해당 책의 장 선택
    final chapters = await controller.chaptersOf(selectedBookId);
    if (!mounted || chapters.isEmpty) return;

    final selectedChapter = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ChapterPickerSheet(
        chapters: chapters,
        selected: controller.chapter,
      ),
    );
    if (selectedChapter == null) return;

    await controller.selectBookAndChapter(
      newBookId: selectedBookId,
      newChapter: selectedChapter,
    );
  }

  Future<void> _pickChapterOnly() async {
    final chapters = await controller.chaptersOf(controller.bookId);
    if (!mounted || chapters.isEmpty) return;

    final selectedChapter = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ChapterPickerSheet(
        chapters: chapters,
        selected: controller.chapter,
      ),
    );
    if (selectedChapter == null) return;

    await controller.selectChapterOnly(selectedChapter);
  }

  @override
  Widget build(BuildContext context) {
    final chapterLabel =
        _formatChapterLabel(controller.bookName, controller.chapter);

    return Scaffold(
      backgroundColor: const Color(0xFF1F1B1A),
      appBar: ReadTopBar(
        bookLabel: controller.bookName,
        chapterLabel: chapterLabel, // ← 규칙 반영된 라벨
        onTapBook: _pickBookThenChapter,
        onTapChapter: _pickChapterOnly,
      ),
      body: controller.loading
          ? const Center(child: CircularProgressIndicator())
          : (controller.verses.isEmpty
              ? const Center(
                  child: Text(
                    '본문이 없습니다.',
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: 12),
                  itemCount: controller.verses.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Colors.white12),
                  itemBuilder: (_, index) {
                    final Verse verse = controller.verses[index];
                    return VerseTile(
                      verse: verse,
                      scrapped: false,
                      onScrapToggle: () async {
                        await controller.toggleScrap(verse);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '스크랩 ${verse.bookId}:${verse.chapter}:${verse.verse}',
                            ),
                          ),
                        );
                      },
                    );
                  },
                )),
    );
  }
}
