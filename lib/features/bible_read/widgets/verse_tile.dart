import 'package:flutter/material.dart';

import '../../../core/models/verse.dart';

class VerseTile extends StatelessWidget {
  final Verse verse;
  final VoidCallback? onScrapToggle;
  final bool scrapped;

  const VerseTile({
    super.key,
    required this.verse,
    this.onScrapToggle,
    this.scrapped = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: false,
      title: Text(
        '${verse.verse}. ${verse.text}',
        style: const TextStyle(
          color: Colors.white, // 텍스트 흰색
        ),
      ),
      trailing: IconButton(
        tooltip: '스크랩 토글',
        icon: Icon(
          scrapped ? Icons.bookmark : Icons.bookmark_border,
          color: Colors.white, // 아이콘도 흰색으로
        ),
        onPressed: onScrapToggle,
      ),
    );
  }
}
