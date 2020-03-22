import 'package:AnimeGo/core/model/OneEpisodeInfo.dart';

/// It is basically `OneEpisodeInfo`
class WatchHistory {
  List<OneEpisodeInfo> history;

  WatchHistory.fromJson(Map<String, dynamic> json) {
    final list = json['history'] as List;
    print(list);
    list.forEach((element) {
      this.history.add(OneEpisodeInfo.fromJson(element));
    });
  }

  Map<String, dynamic> toJson() =>
  {
    'history': history.map((element) => element.toJson()).toList(),
  };
}
