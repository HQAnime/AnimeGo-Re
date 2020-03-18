import 'package:AnimeGo/core/model/VideoServer.dart';
import 'package:html/dom.dart';

/// This only includes info for a `single` episode, like video sources and more
class OneEpisodeInfo {
  String name;
  String category;
  String moreInfo;

  String prevEpisode;
  String nextEpisode;

  List<VideoServer> servers;

  OneEpisodeInfo(Element e) {
    print(e);
  }
}
