
import 'package:AnimeGo/core/model/BasicAnime.dart';

/// It is basically `BasicAnime`
class FavouriteAnime {
  List<BasicAnime> favourite = [];

  FavouriteAnime.fromJson(Map<String, dynamic> json) {
    final list = json['favourite'] as List;
    favourite = list.map((e) => BasicAnime.fromJson(e)).toList(growable: false);
  }

  Map<String, dynamic> toJson() =>
  {
    'favourite': favourite.map((e) => e.toJson()),
  };
}
