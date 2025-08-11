import 'package:flutter/material.dart';

import '../../core/models/scrap.dart';
import '../../core/repo/scrap_repository.dart';

class ScrapsPage extends StatefulWidget {
  const ScrapsPage({super.key});

  @override
  State<ScrapsPage> createState() => _ScrapsPageState();
}

class _ScrapsPageState extends State<ScrapsPage> {
  final repo = ScrapRepository();
  List<Scrap> items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    items = await repo.listScraps();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('스크랩')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final s = items[i];
            return ListTile(
              title: Text('${s.bookId}:${s.chapter}:${s.verse}'),
              subtitle: Text(s.note ?? '메모 없음'),
              trailing: Text('${s.createdAt.toLocal()}'.split('.').first),
            );
          },
        ),
      ),
    );
  }
}
