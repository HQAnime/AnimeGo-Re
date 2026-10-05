import 'package:animego/core/Global.dart';
import 'package:animego/core/model/AnimeDetailedInfo.dart';
import 'package:animego/core/model/AnimeInfo.dart';
import 'package:animego/core/model/BasicAnime.dart';
import 'package:animego/core/model/EpisodeSection.dart';
import 'package:animego/core/model/EpisodelInfo.dart';
import 'package:animego/core/model/OneEpisodeInfo.dart';
import 'package:animego/core/parser/AnimeParser.dart';
import 'package:animego/core/parser/DetailedInfoParser.dart';
import 'package:animego/core/parser/EpisodeListParser.dart';
import 'package:animego/core/parser/OneEpisodeParser.dart';
import 'package:animego/core/source/AnimeSource.dart';

/// The original gogoanime implementation, wrapped behind [AnimeSource].
class GogoanimeSource extends AnimeSource {
  final global = Global();

  @override
  String get id => 'gogoanime';

  @override
  String get name => 'Gogoanime';

  @override
  SourceKind get kind => SourceKind.streaming;

  @override
  bool get supportsBrowse => true;

  @override
  bool get supportsSearch => true;

  @override
  String get baseUrl => global.getDomain();

  /// The relative paths used by the gogoanime browse feeds
  static const _browsePaths = {
    BrowseKind.latest: '/page-recent-release.html',
    BrowseKind.seasonal: '/new-season.html',
    BrowseKind.movie: '/anime-movies.html',
    BrowseKind.popular: '/popular.html',
  };

  /// Build an absolute link and append the page parameter.
  ///
  /// Search links already contain a query string, so they need `&page=`
  /// while every other link needs `?page=`.
  String _pageLink(String path, int page) {
    final base = path.startsWith('http')
        ? path
        : global.getDomain(url: path) + path;
    final separator = base.contains('?') ? '&' : '?';
    return '$base${separator}page=$page';
  }

  Future<List<AnimeInfo>> _load(String path, int page) async {
    final parser = AnimeParser(_pageLink(path, page));
    final body = await parser.downloadHTML();
    return parser.parseHTML(body);
  }

  @override
  Future<List<AnimeInfo>> browse(BrowseKind kind, {int page = 1}) {
    return _load(_browsePaths[kind]!, page);
  }

  @override
  Future<List<AnimeInfo>> search(String keyword, {int page = 1}) {
    final encoded = keyword.split(' ').join('%20');
    return _load('/search.html?keyword=$encoded', page);
  }

  @override
  Future<List<AnimeInfo>> category(String categoryLink, {int page = 1}) {
    return _load(categoryLink, page);
  }

  @override
  Future<List<AnimeInfo>> genre(String genre, {int page = 1}) {
    final formatted = genre.split(' ').join('-').toLowerCase();
    return _load('/genre/$formatted', page);
  }

  @override
  Future<AnimeDetailedInfo?> detail(BasicAnime anime) async {
    final parser =
        DetailedInfoParser(global.getDomain() + (anime.link ?? ''));
    final body = await parser.downloadHTML();
    if (body == null) return null;
    return parser.parseHTML(body);
  }

  @override
  Future<List<EpisodeInfo>> episodes(EpisodeSection section) async {
    const episodeUrl = '/load-list-episode';
    final parser = EpisodeListParser(
      global.getDomain(url: episodeUrl) + episodeUrl,
      section,
    );
    final body = await parser.downloadHTML();
    return parser.parseHTML(body);
  }

  @override
  Future<OneEpisodeInfo?> episode(BasicAnime episode) async {
    final parser =
        OneEpisodeParser(global.getDomain() + (episode.link ?? ''));
    final body = await parser.downloadHTML();
    if (body == null) return null;
    final info = parser.parseHTML(body);
    info.currentEpisodeLink = episode.link;
    return info;
  }
}
