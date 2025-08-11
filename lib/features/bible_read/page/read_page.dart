import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../core/models/verse.dart';
import '../../../core/repo/bible_repository.dart';
import '../../../core/repo/scrap_repository.dart';
import '../controller.dart';
import '../sheets/book_picker_sheet.dart';
import '../sheets/chapter_picker_sheet.dart';
import '../widgets/top_bar.dart';
import '../widgets/verse_tile.dart';

class ReadPage extends StatefulWidget {
  const ReadPage({super.key, this.onReferenceChanged});

  /// 상단 네비 라벨(탭 라벨)을 부모(AppRoot)에 전달
  /// 예: "왕상 12:8" 또는 "시 132:1"
  final void Function(String label)? onReferenceChanged;

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  late final BibleReadController controller;

  // 스크롤 포지션 추적용
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    controller = BibleReadController(
      bible: BibleRepository(),
      scraps: ScrapRepository(),
    );
    controller.addListener(_onControllerChanged);
    controller.init();

    // 가시 아이템(절) 변할 때마다 탭 라벨 업데이트
    itemPositionsListener.itemPositions.addListener(_onVisibleItemsChanged);
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerChanged);
    controller.dispose();
    // 리스너는 제거 불필요(객체 생명주기와 함께 사라짐)지만 안전하게 초기화할 거면 아래처럼:
    // itemPositionsListener.itemPositions.removeListener(_onVisibleItemsChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {});
    // 챕터/책이 바뀌면 리스트를 맨 위(1절)로 스크롤하고 라벨도 갱신
    if (controller.verses.isNotEmpty && itemScrollController.isAttached) {
      itemScrollController.jumpTo(index: 0);
    }
    _notifyParentLabel(currentVerse: 1); // 기본 1절
  }

  void _onVisibleItemsChanged() {
    if (!mounted || controller.verses.isEmpty) return;

    // 현재 화면에 보이는 아이템들 중 "화면 상단에 가장 가까운 index" 선택
    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    final minTop = positions
        .where((p) => p.itemLeadingEdge >= 0) // 화면 위쪽에 걸쳐 있는 것들
        .fold<double?>(
            null,
            (minV, p) => minV == null
                ? p.itemLeadingEdge
                : (p.itemLeadingEdge < minV ? p.itemLeadingEdge : minV));

    // minTop이 없으면 화면 위쪽에 걸친 항목이 없다는 뜻 → 그냥 최소 index 사용
    final visibleIndex = (minTop == null)
        ? positions.map((p) => p.index).reduce((a, b) => a < b ? a : b)
        : positions
            .where((p) => p.itemLeadingEdge == minTop)
            .map((p) => p.index)
            .fold<int>(1 << 30, (a, b) => a < b ? a : b);

    final verseNum =
        (visibleIndex >= 0 && visibleIndex < controller.verses.length)
            ? controller.verses[visibleIndex].verse
            : 1;

    _notifyParentLabel(currentVerse: verseNum);
  }

  // 시편이면 '편' 그 외엔 '장' → 바텀 탭 라벨은 "약칭 chapter:verse"
  // 예: 왕상 12:8 / 시 132:1
  void _notifyParentLabel({required int currentVerse}) {
    if (widget.onReferenceChanged == null) return;
    final abbr = controller.bookAbbr; // 예: 왕상, 시
    final chapter = controller.chapter;
    final label = '$abbr $chapter:$currentVerse';
    widget.onReferenceChanged!(label);
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

    // 챕터 바뀌면 맨 위로 & 라벨 1절로
    if (itemScrollController.isAttached) {
      itemScrollController.jumpTo(index: 0);
    }
    _notifyParentLabel(currentVerse: 1);
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

    if (itemScrollController.isAttached) {
      itemScrollController.jumpTo(index: 0);
    }
    _notifyParentLabel(currentVerse: 1);
  }

  // 상단 칩(책/장) 표기: 시편은 '편', 나머지는 '장'
  String _formatChapterChip(String bookName, int chapter) {
    final isPsalms = bookName == '시편';
    return '$chapter${isPsalms ? '편' : '장'}';
  }

  @override
  Widget build(BuildContext context) {
    final chapterChipLabel =
        _formatChapterChip(controller.bookName, controller.chapter);

    return Scaffold(
      backgroundColor: const Color(0xFF1F1B1A),
      appBar: ReadTopBar(
        bookLabel: controller.bookName,
        chapterLabel: chapterChipLabel,
        onTapBook: _pickBookThenChapter,
        onTapChapter: _pickChapterOnly,
      ),
      body: controller.loading
          ? const Center(child: CircularProgressIndicator())
          : (controller.verses.isEmpty
              ? const Center(
                  child: Text('본문이 없습니다.',
                      style: TextStyle(color: Colors.white70)),
                )
              : ScrollablePositionedList.builder(
                  itemScrollController: itemScrollController,
                  itemPositionsListener: itemPositionsListener,
                  itemCount: controller.verses.length,
                  itemBuilder: (_, index) {
                    final Verse verse = controller.verses[index];
                    return Column(
                      children: [
                        VerseTile(
                          verse: verse,
                          scrapped: false,
                          onScrapToggle: () async {
                            await controller.toggleScrap(verse);
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      '스크랩 ${verse.bookId}:${verse.chapter}:${verse.verse}')),
                            );
                          },
                        ),
                        const Divider(height: 1, color: Colors.white12),
                      ],
                    );
                  },
                )),
    );
  }
}
