import 'package:animego/core/model/AnimeDetailedInfo.dart';
import 'package:animego/core/model/AnimeInfo.dart';
import 'package:animego/core/model/BasicAnime.dart';
import 'package:animego/core/model/EpisodeSection.dart';
import 'package:animego/core/model/EpisodelInfo.dart';
import 'package:animego/core/model/OneEpisodeInfo.dart';
import 'package:animego/core/source/AnimeSource.dart';
import 'package:animego/core/source/nyaa/NyaaParser.dart';
import 'package:http/http.dart' as http;

/// A torrent indexer backed by `nyaa.si`.
///
/// The app never downloads torrents. Each `AnimeInfo` carries the magnet link,
/// and the UI hands it off to the user's installed torrent client.
class NyaaSource extends AnimeSource {
  NyaaSource({String baseUrl = 'https://nyaa.si/'})
      : _baseUrl = _normalize(baseUrl);

  late String _baseUrl;

  static const _userAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/120.0 Safari/537.36';

  /// English-translated anime only; keeps the adult categories out.
  static const _anime = 'c=1_2';

  static String _normalize(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return 'https://nyaa.si/';
    return trimmed.endsWith('/') ? trimmed : '$trimmed/';
  }

  @override
  String get id => 'nyaa';

  @override
  String get name => 'Nyaa';

  @override
  SourceKind get kind => SourceKind.torrent;

  @override
  bool get supportsBrowse => true;

  @override
  bool get supportsSearch => true;

  @override
  bool get isConfigurable => true;

  @override
  String get baseUrl => _baseUrl;

  @override
  void updateBaseUrl(String url) => _baseUrl = _normalize(url);

  @override
  Future<List<AnimeInfo>> browse(BrowseKind kind, {int page = 1}) {
    switch (kind) {
      case BrowseKind.latest:
        return _load('$_anime&s=id&o=desc', page);
      case BrowseKind.popular:
        return _load('$_anime&s=seeders&o=desc', page);
      case BrowseKind.seasonal:
        // "Seasonal" maps to complete-season batches.
        return _load('$_anime&q=batch&s=seeders&o=desc', page);
      case BrowseKind.movie:
        return _load('$_anime&q=movie&s=seeders&o=desc', page);
    }
  }

  @override
  Future<List<AnimeInfo>> search(String keyword, {int page = 1}) {
    final query = Uri.encodeQueryComponent(keyword);
    return _load('$_anime&q=$query&s=seeders&o=desc', page);
  }

  @override
  Future<List<AnimeInfo>> category(String categoryLink, {int page = 1}) {
    // Only query strings are meaningful; source relative paths are ignored.
    if (!categoryLink.startsWith('?')) return Future.value([]);
    return _load(categoryLink.substring(1), page);
  }

  @override
  Future<List<AnimeInfo>> genre(String genre, {int page = 1}) async => [];

  @override
  Future<AnimeDetailedInfo?> detail(BasicAnime anime) async => null;

  @override
  Future<List<EpisodeInfo>> episodes(EpisodeSection section) async => [];

  @override
  Future<OneEpisodeInfo?> episode(BasicAnime episode) async => null;

  Future<List<AnimeInfo>> _load(String query, int page) async {
    final base = '$_baseUrl?$query';
    final url = page > 1 ? '$base&p=$page' : base;
    final res = await http.get(
      Uri.parse(url),
      headers: {'User-Agent': _userAgent, 'Accept': 'text/html'},
    );
    if (res.statusCode != 200) return [];
    return NyaaParser.parse(res.body).map(_toInfo).toList();
  }

  AnimeInfo _toInfo(TorrentRelease release) {
    final parts = <String>[];
    if (release.size != null && release.size!.isNotEmpty) {
      parts.add(release.size!);
    }
    if (release.seeders != null) parts.add('${release.seeders} seeders');
    return AnimeInfo.create(
      name: release.title,
      link: release.magnet,
      episode: parts.isEmpty ? '??' : parts.join(' · '),
    );
  }
}
