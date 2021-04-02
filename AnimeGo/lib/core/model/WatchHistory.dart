import 'package:animego/core/model/BasicAnime.dart';
import 'package:animego/core/model/BasicAnimeList.dart';
import 'package:animego/core/model/OneEpisodeInfo.dart';

class WatchHistory extends BasicAnimeList {
  WatchHistory();
  WatchHistory.fromJson(
    Map<String, dynamic> json,
  ) : super.fromJson(json);

  @override
  bool contains(BasicAnime? anime) {
    if (anime is OneEpisodeInfo) {
      return list.any((e) => e?.name == anime.episodeName);
    } else {
      return list.any((e) => e?.name == anime?.name);
    }
  }

  @override
  String getName() => 'history';
}
