import 'package:AnimeGo/core/model/BasicAnime.dart';

/// It is basically a list of `BasicAnime`
abstract class BasicAnimeList {
  List<BasicAnime> list = [];
  bool contains(BasicAnime anime) => list.any((e) => e.link == anime.link);
  void add(BasicAnime anime) {
    if (contains(anime)) return;
    list.add(anime);
  }

  BasicAnimeList.fromJson(Map<String, dynamic> json) {
    final temp = json[getName()] as List;
    list = temp.map((e) => BasicAnime.fromJson(e)).toList(growable: false);
  }

  Map<String, dynamic> toJson() =>
  {
    getName(): list.map((e) => e.toJson()),
  };

  String getName();
}
