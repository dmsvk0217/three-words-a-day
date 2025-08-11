import 'package:flutter/foundation.dart';

import '../../core/models/scrap.dart';
import '../../core/repo/scrap_repository.dart';

class ScrapsController extends ChangeNotifier {
  final ScrapRepository repo;
  ScrapsController({required this.repo});

  List<Scrap> _items = [];
  List<Scrap> get items => _items;

  Future<void> refresh() async {
    _items = await repo.listScraps();
    notifyListeners();
  }
}
