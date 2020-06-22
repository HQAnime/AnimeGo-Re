import 'package:AnimeGo/core/model/BasicAnime.dart';
import 'package:AnimeGo/core/model/VideoServer.dart';
import 'package:html/dom.dart';

/// This only includes info for a `single` episode, like video sources and more
class OneEpisodeInfo extends BasicAnime{
  String category;
  String categoryLink;

  String currentEpisode;
  String prevEpisodeLink;
  String nextEpisodeLink;
  String get episodeName => '[$currentEpisode] $name';

  List<VideoServer> servers = [];

  /// Only need to save current episode
  Map<String, dynamic> toJson() =>
  {
    'name': name,
    'link': link,
    'currentEpisode': currentEpisode,
  };

  OneEpisodeInfo.fromJson(Map<String, dynamic> json) :
    this.currentEpisode = json['currentEpisode'],
    super.fromJson(json);

  OneEpisodeInfo(Element e) : super.fromJson(null) {
    // Get name and category
    final body = e.getElementsByClassName('anime_video_body_cate').first;
    final rawTitle = e.nodes[1].text;
    final regex = RegExp(r"Episode (\w.*?) ");
    final match = regex.firstMatch(rawTitle);
    this.currentEpisode = match.group(1);

    final categoryClass = body.nodes[3];
    this.category = categoryClass.attributes['title'];
    this.categoryLink = categoryClass.attributes['href'];

    final nameClass = body.nodes[5].nodes[3];
    this.name = nameClass.attributes['title'];
    this.link = nameClass.attributes['href'];

    // Get all video servers
    final server = e.getElementsByClassName('anime_muti_link').first;
    final serverList = server.nodes[1];
    serverList.nodes.forEach((element) {
      if (element.runtimeType == Element) {
        // Add to servers
        this.servers.add(VideoServer(element));
      }
    });

    final episode = e.getElementsByClassName('anime_video_body_episodes').first;
    // TODO: make this look nicer
    try {
      this.nextEpisodeLink = episode.nodes[3].nodes[1].attributes['href'];
    } catch (_) { }
    try {
      this.prevEpisodeLink = episode.nodes[1].nodes[1].attributes['href'];
    } catch (_) { }
  }
}
