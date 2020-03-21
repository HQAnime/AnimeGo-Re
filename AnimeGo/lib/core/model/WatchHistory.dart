import 'package:AnimeGo/core/model/BasicAnime.dart';
import 'package:AnimeGo/core/model/OneEpisodeInfo.dart';

/// The combination of `BasicAnime` and `OneEpisodeInfo`
class WatchHistory {
  BasicAnime anime;
  OneEpisodeInfo episode;

  WatchHistory(this.anime, this.episode);
}
