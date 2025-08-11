import 'package:flutter/material.dart';
import 'package:three_words_a_day/features/bible_read/page/read_page.dart';
import 'package:three_words_a_day/features/scraps/scraps_page.dart';
import 'package:three_words_a_day/features/settings/settings_page.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});
  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  int idx = 0;

  // 탭 라벨(초기엔 '읽기'로 표시, 페이지가 로드되면 ReadPage가 업데이트해줌)
  String tab1Label = '읽기';
  String tab2Label = '읽기';

  @override
  Widget build(BuildContext context) {
    final pages = [
      ReadPage(
        onReferenceChanged: (label) => setState(() => tab1Label = label),
      ), // 탭1
      ReadPage(
        onReferenceChanged: (label) => setState(() => tab2Label = label),
      ), // 탭2
      const ScrapsPage(), // 탭3
      const SettingsPage(), // 탭4
    ];

    return Scaffold(
      body: IndexedStack(index: idx, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) => setState(() => idx = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            label: tab1Label, // ← 현재 책/장으로 갱신
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined), // ← 2번째도 읽기 아이콘
            label: tab2Label,
          ),
          const NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            label: '스크랩',
          ),
          const NavigationDestination(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }
}
