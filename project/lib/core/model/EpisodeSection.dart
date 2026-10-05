import 'package:html/dom.dart';

/// This contains maximum 100 episode
class EpisodeSection {
  String? episodeStart;
  String? episodeEnd;
  String? movieID;

  /// Source specific payload used to resolve the episode list.
  ///
  /// For gogoanime this is the `?ep_start=..&ep_end=..&id=..` query. Other
  /// sources can store their own identifier here.
  String? payload;

  EpisodeSection(Element e, this.movieID) {
    final episode = e.nodes[1];
    this.episodeStart = episode.attributes['ep_start'];
    this.episodeEnd = episode.attributes['ep_end'];
    this.payload =
        '?ep_start=$episodeStart&ep_end=$episodeEnd&id=$movieID';
  }

  /// Build a section without parsing HTML, used by non-HTML sources.
  EpisodeSection.create({
    this.episodeStart,
    this.episodeEnd,
    this.movieID,
    this.payload,
  });

  String getLink() => payload ?? '';
}
