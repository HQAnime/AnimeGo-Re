import 'package:animego/core/model/AnimeDetailedInfo.dart';
import 'package:animego/core/model/AnimeInfo.dart';
import 'package:animego/core/model/BasicAnime.dart';
import 'package:animego/core/model/EpisodeSection.dart';
import 'package:animego/core/model/EpisodelInfo.dart';
import 'package:animego/core/model/OneEpisodeInfo.dart';

/// The type of content a source provides
enum SourceKind {
  streaming,
  torrent,
}

/// The different browse feeds a source can expose
enum BrowseKind {
  latest,
  seasonal,
  movie,
  popular,
}

/// A torrent release returned by a [SourceKind.torrent] source
class TorrentRelease {
  String? title;
  String? magnet;
  String? size;
  int? seeders;
  int? leechers;

  TorrentRelease({
    this.title,
    this.magnet,
    this.size,
    this.seeders,
    this.leechers,
  });
}

/// The contract every content source must implement.
///
/// The app only ever talks to this interface, never to a website directly,
/// so new sources can be added without touching the UI.
abstract class AnimeSource {
  /// Stable identifier, e.g. `gogoanime`
  String get id;

  /// Human readable name shown in the source picker
  String get name;

  /// Whether this source streams or provides torrents
  SourceKind get kind;

  /// Whether the browse feeds are available
  bool get supportsBrowse;

  /// Whether search is available
  bool get supportsSearch;

  /// Base URL used for network requests and the Cloudflare challenge.
  String get baseUrl => '';

  /// Whether this source sits behind Cloudflare and needs the native bypass.
  bool get requiresCloudflare => false;

  /// Latest / seasonal / movie / popular feeds
  Future<List<AnimeInfo>> browse(BrowseKind kind, {int page = 1});

  /// Search by keyword
  Future<List<AnimeInfo>> search(String keyword, {int page = 1});

  /// Browse a category (source specific link/id)
  Future<List<AnimeInfo>> category(String categoryLink, {int page = 1});

  /// Browse a genre by its display name
  Future<List<AnimeInfo>> genre(String genre, {int page = 1});

  /// Detailed info for a single anime
  Future<AnimeDetailedInfo?> detail(BasicAnime anime);

  /// Resolve the episodes contained in an episode section
  Future<List<EpisodeInfo>> episodes(EpisodeSection section);

  /// Info (and video servers) for a single episode
  Future<OneEpisodeInfo?> episode(BasicAnime episode);
}
