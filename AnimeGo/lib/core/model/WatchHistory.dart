import 'package:AnimeGo/core/model/BasicAnime.dart';

/// It is basically `BasicAnime`
class WatchHistory {
  List<BasicAnime> history = [];

  WatchHistory.fromJson(Map<String, dynamic> json) {
    final list = json['history'] as List;
    history = list.map((e) => BasicAnime.fromJson(e)).toList(growable: false);
  }

  Map<String, dynamic> toJson() =>
  {
    'history': history.map((e) => e.toJson()),
  };
}
