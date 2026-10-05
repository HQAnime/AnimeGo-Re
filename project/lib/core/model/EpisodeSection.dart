/// This contains maximum 100 episode
class EpisodeSection {
  String? episodeStart;
  String? episodeEnd;
  String? movieID;

  /// Source specific payload used to resolve the episode list.
  ///
  /// A streaming source stores its own identifier here (for HiAnime it is the
  /// numeric anime id).
  String? payload;

  /// The only way to build a section; sources pass their own payload.
  EpisodeSection.create({
    this.episodeStart,
    this.episodeEnd,
    this.movieID,
    this.payload,
  });

  String getLink() => payload ?? '';
}
