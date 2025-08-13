import 'package:flutter/material.dart';

import '../../core/models/scrap.dart';
import '../../core/repo/bible_repository.dart'; // ★ 책/절 조회용
import '../../core/repo/scrap_repository.dart';

class ScrapsPage extends StatefulWidget {
  const ScrapsPage({super.key});

  @override
  State<ScrapsPage> createState() => _ScrapsPageState();
}

class _ScrapsPageState extends State<ScrapsPage> {
  final scrapsRepo = ScrapRepository();
  final bibleRepo = BibleRepository(); // ★ 추가

  List<Scrap> items = [];

  // 간단 캐시 (스크롤 시 매번 DB조회 방지)
  final Map<String, _ScrapVM> _cache = {};
  String _keyOf(Scrap s) => '${s.bookId}:${s.chapter}:${s.verse}';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    items = await scrapsRepo.listScraps();
    if (mounted) setState(() {});
  }

  Future<_ScrapVM> _loadVM(Scrap s) async {
    final k = _keyOf(s);
    if (_cache.containsKey(k)) return _cache[k]!;
    // 책 이름 / 절 본문 읽기 (repo 메서드 이름은 프로젝트에 맞게 조정하세요)
    final book = await bibleRepo.getBookById(s.bookId); // Book(id,name,abbr)
    final verse =
        await bibleRepo.getVerse(s.bookId, s.chapter, s.verse); // Verse(text)
    final vm = _ScrapVM(
      title: '${book.name} ${s.chapter}:${s.verse}',
      text: verse.text,
    );
    _cache[k] = vm;
    return vm;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('스크랩')),
      body: RefreshIndicator(
        onRefresh: () async {
          _cache.clear();
          await _load();
        },
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final s = items[i];
            return FutureBuilder<_ScrapVM>(
              future: _loadVM(s),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return _scrapCardSkeleton(context); // 로딩 상태
                }
                final vm = snap.data!;
                return _scrapCard(
                  context: context,
                  title: vm.title, // 예: "잠언 10:7"
                  text: vm.text, // 본문
                );
              },
            );
          },
        ),
      ),
    );
  }

  // ---- 카드 위젯: 스샷 느낌(라이트 카드, 둥근 모서리, 연한 테두리) ----
  Widget _scrapCard({
    required BuildContext context,
    required String title,
    required String text,
  }) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface, // 밝은 카드색(라이트/다크 테마 대응)
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? Colors.white12
              : Colors.black12,
        ),
        boxShadow: [
          // 아주 약한 그림자 (이미지 느낌)
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 타이틀: "잠언 10:7"
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          // 본문 여러 줄
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  // 로딩용 스켈레톤 (간단)
  Widget _scrapCardSkeleton(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? Colors.white12
              : Colors.black12,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 16, width: 110, color: Colors.black12),
          const SizedBox(height: 10),
          Container(height: 14, color: Colors.black12),
          const SizedBox(height: 6),
          Container(height: 14, width: 220, color: Colors.black12),
        ],
      ),
    );
  }
}

// 뷰모델
class _ScrapVM {
  final String title;
  final String text;
  _ScrapVM({required this.title, required this.text});
}
