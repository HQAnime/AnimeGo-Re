import 'package:AnimeGo/core/model/BasicAnimeList.dart';

import 'BasicAnime.dart';
import 'OneEpisodeInfo.dart';

class FavouriteAnime extends BasicAnimeList {
  FavouriteAnime();
  FavouriteAnime.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  bool contains(BasicAnime anime) {
    if (anime is OneEpisodeInfo) {
      return list.any((e) => e.name == anime.episodeName);
    }

    throw new Exception('contains() in FavouriteAnime should take in an OneEpisodeInfo');
  }
  

  @override
  String getName() => 'favourite';
}
