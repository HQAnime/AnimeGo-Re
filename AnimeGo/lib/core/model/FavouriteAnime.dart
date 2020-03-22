
import 'package:AnimeGo/core/model/AnimeDetailedInfo.dart';

/// It is basically `OneEpisodeInfo`
class FavouriteAnime {
  List<AnimeDetailedInfo> favourite;

  FavouriteAnime.fromJson(Map<String, dynamic> json) {
    final list = json['favourite'] as List;
    print(list);
    list.forEach((element) {
      favourite.add(AnimeDetailedInfo.fromJson(element));
    });
  }

  Map<String, dynamic> toJson() =>
  {
    'favourite': favourite.map((element) => element.toJson()).toList(),
  };
}
