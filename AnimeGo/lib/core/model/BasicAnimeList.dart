import 'package:AnimeGo/core/model/BasicAnime.dart';
import 'package:AnimeGo/core/model/OneEpisodeInfo.dart';

/// It is basically a list of `BasicAnime`
abstract class BasicAnimeList {
  List<BasicAnime> list = [];
  bool contains(OneEpisodeInfo anime) => list.any((e) => e.name == anime.episodeName);
  void add(BasicAnime anime) {
    if (contains(anime)) return;
    list.insert(0, anime);
  }
  void remove(BasicAnime anime) {
    list.removeWhere((e) => e.link == anime.link);
  }

  BasicAnimeList();
  BasicAnimeList.fromJson(Map<String, dynamic> json) {
    final temp = json[getName()] as List;
    list = temp.map((e) => BasicAnime.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() =>
  {
    getName(): list.map((e) => e.toJson()).toList(growable: false),
  };

  String getName();
}
