import 'package:animego/core/model/AnimeGenre.dart';
import 'package:animego/core/model/EpisodeSection.dart';

/// This contains the detailed anime info including descriptions
class AnimeDetailedInfo {
  String? image;
  String? name;
  String? category;
  String? categoryLink;
  String? summary;
  List<AnimeGenre> genre = [];
  String? released;
  String? status;

  /// A list of episode (1 - 100, 101 - 200 and so on)
  List<EpisodeSection> episodes = [];
  String? lastEpisode;

  /// Canonical ids (resolved from AniList) used to match this anime across
  /// sources. Null until [SourceManager] enriches the detail.
  int? anilistId;
  int? malId;

  /// The only way to build this; sources pass the fields they parsed.
  AnimeDetailedInfo.create({
    this.image,
    this.name,
    this.category,
    this.categoryLink,
    this.summary,
    List<AnimeGenre>? genre,
    this.released,
    this.status,
    List<EpisodeSection>? episodes,
    this.lastEpisode,
    this.anilistId,
    this.malId,
  }) {
    if (genre != null) this.genre = genre;
    if (episodes != null) this.episodes = episodes;
  }
}
