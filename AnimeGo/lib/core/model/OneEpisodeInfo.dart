import 'package:AnimeGo/core/model/VideoServer.dart';
import 'package:html/dom.dart';

/// This only includes info for a `single` episode, like video sources and more
class OneEpisodeInfo {
  String name;
  String animeLink;
  String category;
  String categoryLink;

  String prevEpisode;
  String nextEpisode;

  List<VideoServer> servers = [];

  OneEpisodeInfo(Element e) {
    // Get name and category
    final body = e.getElementsByClassName('anime_video_body_cate').first;

    final categoryClass = body.nodes[3];
    this.category = categoryClass.attributes['title'];
    this.categoryLink = categoryClass.attributes['href'];

    final nameClass = body.nodes[5].nodes[3];
    this.name = nameClass.attributes['title'];
    this.animeLink = nameClass.attributes['href'];

    // Get all video servers
    final server = e.getElementsByClassName('anime_muti_link').first;
    final serverList = server.nodes[1];
    serverList.nodes.forEach((element) {
      if (element.runtimeType == Element) {
        // Add to servers
        this.servers.add(VideoServer(element));
      }
    });
  }
}
