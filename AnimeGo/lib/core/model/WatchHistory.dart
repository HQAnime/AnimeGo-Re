import 'package:AnimeGo/core/model/BasicAnimeList.dart';

class WatchHistory extends BasicAnimeList {
  WatchHistory();
  WatchHistory.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String getName() => 'history';
}
