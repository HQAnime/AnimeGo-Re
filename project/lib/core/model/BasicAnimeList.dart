import 'package:animego/core/model/BasicAnime.dart';

/// It is basically a list of `BasicAnime`
abstract class BasicAnimeList {
  List<BasicAnime?> list = [];
  bool contains(BasicAnime? anime) {
    return list.any((e) {
      return e?.link == anime?.link;
    });
  }

  void add(BasicAnime? anime) {
    if (contains(anime)) return;
    list.insert(0, anime);
  }

  void remove(BasicAnime? anime) {
    list.removeWhere((e) {
      return e?.link == anime?.link;
    });
  }

  BasicAnimeList();
  BasicAnimeList.fromJson(Map<String, dynamic> json) {
    final temp = json[getName()] as List;
    list = temp.map((e) => BasicAnime.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() =>
      {getName(): list.map((e) => e?.toJson()).toList(growable: false)};

  String getName();
}
