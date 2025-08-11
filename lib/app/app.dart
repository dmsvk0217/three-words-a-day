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

  @override
  Widget build(BuildContext context) {
    final pages = const [
      ReadPage(), // 탭1: 본문 읽기1
      ReadPage(), // 탭2: 본문 읽기2
      ScrapsPage(), // 탭3: 스크랩 목록
      SettingsPage(), // 탭4: 설정(알림, 소개)
    ];
    return Scaffold(
      body: IndexedStack(index: idx, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) => setState(() => idx = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.menu_book_outlined), label: '읽기'),
          NavigationDestination(icon: Icon(Icons.search), label: '탐색'),
          NavigationDestination(
              icon: Icon(Icons.bookmark_border), label: '스크랩'),
          NavigationDestination(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }
}
