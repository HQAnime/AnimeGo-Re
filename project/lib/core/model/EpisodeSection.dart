import 'package:html/dom.dart';

/// This contains maximum 100 episode
class EpisodeSection {
  String? episodeStart;
  String? episodeEnd;
  String? movieID;

  EpisodeSection(Element e, this.movieID) {
    final episode = e.nodes[1];
    this.episodeStart = episode.attributes['ep_start'];
    this.episodeEnd = episode.attributes['ep_end'];
  }

  String getLink() => '?ep_start=$episodeStart&ep_end=$episodeEnd&id=$movieID';
}
