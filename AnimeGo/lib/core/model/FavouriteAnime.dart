import 'package:AnimeGo/core/model/BasicAnimeList.dart';

class FavouriteAnime extends BasicAnimeList {
  FavouriteAnime();
  FavouriteAnime.fromJson(Map<String, dynamic> json) : super.fromJson(json);  

  @override
  String getName() => 'favourite';
}
