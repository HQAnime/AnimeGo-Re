import 'package:animego/core/model/BasicAnime.dart';

class EpisodeInfo extends BasicAnime {
  /// The only way to build an episode entry; sources pass name and link.
  EpisodeInfo.create({String? name, String? link}) : super.fromJson(null) {
    this.name = name;
    this.link = link;
  }
}
