import 'package:animego/core/model/AnimeDetailedInfo.dart';
import 'package:animego/core/model/AnimeInfo.dart';
import 'package:animego/core/model/BasicAnime.dart';
import 'package:animego/core/model/EpisodeSection.dart';
import 'package:animego/core/model/EpisodelInfo.dart';
import 'package:animego/core/model/OneEpisodeInfo.dart';
import 'package:animego/core/source/AnimeSource.dart';

/// Miruro is an AniList backed Vite SPA.
///
/// Its catalogue, search and stream URLs are built client side from an
/// encrypted REST payload, so scraping it would mean reimplementing a private,
/// obfuscated protocol. Instead this source embeds the website itself (see
/// `WebSourcePage`), blocks pop-ups and ads, and lets Miruro's own player run.
class MiruroSource extends AnimeSource {
  MiruroSource({String baseUrl = 'https://www.miruro.tv/'})
      : _baseUrl = _normalize(baseUrl);

  late String _baseUrl;

  static String _normalize(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return 'https://www.miruro.tv/';
    return trimmed.endsWith('/') ? trimmed : '$trimmed/';
  }

  @override
  String get id => 'miruro';

  @override
  String get name => 'Miruro';

  @override
  SourceKind get kind => SourceKind.streaming;

  @override
  bool get supportsBrowse => false;

  @override
  bool get supportsSearch => false;

  @override
  bool get isWebView => true;

  @override
  bool get isConfigurable => true;

  @override
  String get baseUrl => _baseUrl;

  @override
  String get webHomeUrl => _baseUrl;

  @override
  void updateBaseUrl(String url) => _baseUrl = _normalize(url);

  // A web-only source is never scraped; the UI shows the WebView instead.

  @override
  Future<List<AnimeInfo>> browse(BrowseKind kind, {int page = 1}) async => [];

  @override
  Future<List<AnimeInfo>> search(String keyword, {int page = 1}) async => [];

  @override
  Future<List<AnimeInfo>> category(String categoryLink, {int page = 1}) async =>
      [];

  @override
  Future<List<AnimeInfo>> genre(String genre, {int page = 1}) async => [];

  @override
  Future<AnimeDetailedInfo?> detail(BasicAnime anime) async => null;

  @override
  Future<List<EpisodeInfo>> episodes(EpisodeSection section) async => [];

  @override
  Future<OneEpisodeInfo?> episode(BasicAnime episode) async => null;

  @override
  String toString() => 'MiruroSource($id)';
}
