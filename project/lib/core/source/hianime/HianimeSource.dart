import 'dart:convert';

import 'package:animego/core/http/RequestService.dart';
import 'package:animego/core/model/AnimeDetailedInfo.dart';
import 'package:animego/core/model/AnimeInfo.dart';
import 'package:animego/core/model/BasicAnime.dart';
import 'package:animego/core/model/EpisodeSection.dart';
import 'package:animego/core/model/EpisodelInfo.dart';
import 'package:animego/core/model/OneEpisodeInfo.dart';
import 'package:animego/core/source/AnimeSource.dart';
import 'package:animego/core/source/hianime/HianimeParser.dart';

/// HiAnime (formerly AniWatch / Zoro).
///
/// The site is a Laravel app that renders anime/search/detail pages as HTML
/// and exposes an internal REST API for episode lists and server links.
class HianimeSource extends AnimeSource {
  HianimeSource({
    String baseUrl = 'https://hianime.tr/',
    String id = 'hianime',
    String name = 'HiAnime',
  })  : _id = id,
        _name = name,
        _baseUrl = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';

  late String _baseUrl;

  final String _id;
  final String _name;

  @override
  String get baseUrl => _baseUrl;

  @override
  String get id => _id;

  @override
  String get name => _name;

  @override
  SourceKind get kind => SourceKind.streaming;

  @override
  bool get supportsBrowse => true;

  @override
  bool get supportsSearch => true;

  @override
  bool get requiresCloudflare => false;

  @override
  bool get isConfigurable => true;

  @override
  void updateBaseUrl(String url) {
    if (url.trim().isEmpty) return;
    _baseUrl = url.trim().endsWith('/') ? url.trim() : '${url.trim()}/';
  }

  static const _browsePaths = {
    BrowseKind.latest: '/home',
    BrowseKind.seasonal: '/tv',
    BrowseKind.movie: '/movie',
    BrowseKind.popular: '/most-popular',
  };

  RequestService get _http => RequestService(
        sourceId: id,
        baseUrl: baseUrl,
        extraHeaders: {'x-requested-with': 'XMLHttpRequest'},
      );

  String _page(String path, int page) {
    return '$path${path.contains('?') ? '&' : '?'}page=$page';
  }

  Future<List<AnimeInfo>> _cards(String path) async {
    final res = await _http.get(path);
    if (res == null || res.statusCode != 200) return [];
    return HianimeParser.parseCards(res.body);
  }

  @override
  Future<List<AnimeInfo>> browse(BrowseKind kind, {int page = 1}) {
    return _cards(_page(_browsePaths[kind] ?? '/home', page));
  }

  @override
  Future<List<AnimeInfo>> search(String keyword, {int page = 1}) {
    final encoded = Uri.encodeComponent(keyword);
    return _cards('/search?keyword=$encoded&page=$page');
  }

  @override
  Future<List<AnimeInfo>> category(String categoryLink, {int page = 1}) {
    return _cards(_page(categoryLink, page));
  }

  @override
  Future<List<AnimeInfo>> genre(String genre, {int page = 1}) {
    final slug = genre
        .toLowerCase()
        .replaceAll(' & ', '-')
        .replaceAll(' ', '-');
    return _cards('/genres/$slug?page=$page');
  }

  @override
  Future<AnimeDetailedInfo?> detail(BasicAnime anime) async {
    final link = anime.link;
    if (link == null) return null;
    final res = await _http.get(link);
    if (res == null || res.statusCode != 200) return null;
    return HianimeParser.parseDetail(res.body);
  }

  @override
  Future<List<EpisodeInfo>> episodes(EpisodeSection section) async {
    final animeId = section.payload;
    if (animeId == null) return [];
    return _episodes(animeId);
  }

  Future<List<EpisodeInfo>> _episodes(String animeId) async {
    final json = await _getJson('api/theme/episode/list/$animeId');
    final html = json?['html']?.toString();
    if (json?['status'] != true || html == null) return [];
    return HianimeParser.parseEpisodes(html);
  }

  @override
  Future<OneEpisodeInfo?> episode(BasicAnime episode) async {
    final link = episode.link;
    if (link == null) return null;

    final uri = Uri.tryParse(link);
    final epId = uri?.queryParameters['ep'];
    final epNumber = uri?.queryParameters['epnum'];
    final animeId = HianimeParser.animeIdFromSlug(uri?.path);
    if (epId == null) return null;

    final json = await _getJson('api/theme/episode/servers?episodeId=$epId');
    final html = json?['html']?.toString();
    if (json?['status'] != true || html == null) {
      return OneEpisodeInfo.create(
        currentEpisode: epNumber,
        currentEpisodeLink: link,
      );
    }

    final servers = HianimeParser.parseServers(html);

    // Resolve previous / next episodes from the episode list.
    String? prev;
    String? next;
    if (animeId != null) {
      final list = await _episodes(animeId);
      final index = list.indexWhere((e) => _hasEpisodeId(e.link, epId));
      if (index >= 0) {
        if (index > 0) prev = list[index - 1].link;
        if (index < list.length - 1) next = list[index + 1].link;
      }
    }

    return OneEpisodeInfo.create(
      name: _nameFromLink(uri?.path),
      link: link,
      currentEpisode: epNumber,
      currentEpisodeLink: link,
      prevEpisodeLink: prev,
      nextEpisodeLink: next,
      servers: servers,
    );
  }

  bool _hasEpisodeId(String? link, String epId) {
    if (link == null) return false;
    return RegExp('[?&]ep=$epId(&|\$)').hasMatch(link);
  }

  String _nameFromLink(String? path) {
    if (path == null) return 'Episode';
    var slug = path.split('/').last;
    slug = slug.replaceFirst(RegExp(r'-\d+$'), '');
    return slug.replaceAll('-', ' ');
  }

  Future<Map<String, dynamic>?> _getJson(String path) async {
    final res = await _http.get(path);
    if (res == null || res.statusCode != 200) return null;
    try {
      final decoded = jsonDecode(res.body);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (e) {
      print('HianimeSource JSON error for $path: $e');
      return null;
    }
  }

  @override
  String toString() => 'HianimeSource($id)';
}
