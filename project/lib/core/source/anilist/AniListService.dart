import 'dart:convert';

import 'package:animego/core/model/CanonicalInfo.dart';
import 'package:http/http.dart' as http;

/// Talks to the public AniList GraphQL API (no auth required).
///
/// Results are cached in memory so the same title is only resolved once per
/// app run. A client can be injected for tests.
class AniListService {
  AniListService({http.Client? client}) : _client = client ?? http.Client();

  /// Shared instance used by the app.
  static final AniListService instance = AniListService();

  static const _endpoint = 'https://graphql.anilist.co';

  static const _fields = 'id idMal title { romaji english } '
      'coverImage { large } description(asHtml: false) episodes status genres';

  final http.Client _client;
  final Map<String, CanonicalInfo?> _cache = {};

  /// Resolve the best AniList match for a title.
  Future<CanonicalInfo?> search(String title) {
    final key = 'q:${title.toLowerCase()}';
    if (_cache.containsKey(key)) return Future.value(_cache[key]);
    return _fetch(
      key,
      'query (\$search: String) { Media(search: \$search, type: ANIME) { '
      '$_fields } }',
      {'search': title},
    );
  }

  /// Resolve a specific AniList id.
  Future<CanonicalInfo?> byId(int id) {
    final key = 'id:$id';
    if (_cache.containsKey(key)) return Future.value(_cache[key]);
    return _fetch(
      key,
      'query (\$id: Int) { Media(id: \$id, type: ANIME) { $_fields } }',
      {'id': id},
    );
  }

  Future<CanonicalInfo?> _fetch(
    String cacheKey,
    String query,
    Map<String, dynamic> variables,
  ) async {
    try {
      final res = await _client.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'query': query, 'variables': variables}),
      );
      if (res.statusCode != 200) return _cache[cacheKey] = null;
      final decoded = jsonDecode(res.body);
      if (decoded is! Map<String, dynamic>) return _cache[cacheKey] = null;
      final media = (decoded['data'] as Map<String, dynamic>?)?['Media'];
      if (media is! Map<String, dynamic>) return _cache[cacheKey] = null;
      return _cache[cacheKey] = CanonicalInfo.fromAniList(media);
    } catch (e) {
      return _cache[cacheKey] = null;
    }
  }
}
