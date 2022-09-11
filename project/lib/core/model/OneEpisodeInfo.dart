import 'package:animego/core/model/BasicAnime.dart';
import 'package:animego/core/model/VideoServer.dart';
import 'package:html/dom.dart';

/// This only includes info for a `single` episode, like video sources and more
class OneEpisodeInfo extends BasicAnime {
  String? category;
  String? categoryLink;

  String? currentEpisode;
  String? currentEpisodeLink;
  String? prevEpisodeLink;
  String? nextEpisodeLink;
  String get episodeName => '[$currentEpisode] $name';

  List<VideoServer> servers = [];

  /// Only need to save current episode
  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'link': link,
        'currentEpisode': currentEpisode,
      };

  OneEpisodeInfo.fromJson(Map<String, dynamic> json)
      : currentEpisode = json['currentEpisode'],
        super.fromJson(json);

  OneEpisodeInfo(Element? e) : super.fromJson(null) {
    // Get name and category
    final body = e?.getElementsByClassName('anime_video_body_cate').first;
    final rawTitle = e?.nodes[1].text;
    if (rawTitle != null) {
      final regex = RegExp(r"Episode (\w.*?) ");
      final match = regex.firstMatch(rawTitle);
      currentEpisode = match?.group(1);
    }

    final categoryClass = body?.nodes[3];
    category = categoryClass?.attributes['title'];
    categoryLink = categoryClass?.attributes['href'];

    final nameClass = body?.nodes[5].nodes[3];
    name = nameClass?.attributes['title'];
    link = nameClass?.attributes['href'];

    // Get all video servers
    final server = e?.getElementsByClassName('anime_muti_link').first;
    final serverList = server?.nodes[1];
    for (final element in serverList?.nodes ?? []) {
      if (element.runtimeType == Element) {
        // Add to servers
        servers.add(VideoServer(element as Element));
      }
    }

    final episode =
        e?.getElementsByClassName('anime_video_body_episodes').first;

    // TODO: make this look nicer
    try {
      nextEpisodeLink = episode?.nodes[3].nodes[1].attributes['href'];
    } catch (_) {}
    try {
      prevEpisodeLink = episode?.nodes[1].nodes[1].attributes['href'];
    } catch (_) {}
  }
}
