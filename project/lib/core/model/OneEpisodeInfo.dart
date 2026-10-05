import 'package:animego/core/model/BasicAnime.dart';
import 'package:animego/core/model/VideoServer.dart';

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
      : this.currentEpisode = json['currentEpisode'],
        super.fromJson(json);

  /// The only way to build this; sources pass the fields they resolved.
  OneEpisodeInfo.create({
    String? name,
    String? link,
    this.category,
    this.categoryLink,
    this.currentEpisode,
    this.currentEpisodeLink,
    this.prevEpisodeLink,
    this.nextEpisodeLink,
    List<VideoServer>? servers,
  }) : super.fromJson(null) {
    this.name = name;
    this.link = link;
    if (servers != null) this.servers = servers;
  }
}
