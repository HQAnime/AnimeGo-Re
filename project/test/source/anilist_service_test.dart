import 'dart:convert';

import 'package:animego/core/model/CanonicalInfo.dart';
import 'package:animego/core/source/anilist/AniListService.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('CanonicalInfo.fromAniList', () {
    test('maps the media payload', () {
      final info = CanonicalInfo.fromAniList({
        'id': 21,
        'idMal': 21,
        'title': {'romaji': 'ONE PIECE', 'english': 'One Piece'},
        'coverImage': {'large': 'https://x/c.jpg'},
        'description': 'Pirates',
        'episodes': null,
        'status': 'RELEASING',
        'genres': ['Action', 'Adventure'],
      });

      expect(info.anilistId, 21);
      expect(info.malId, 21);
      expect(info.title, 'One Piece');
      expect(info.coverImage, 'https://x/c.jpg');
      expect(info.episodes, isNull);
      expect(info.genres, ['Action', 'Adventure']);
    });

    test('falls back to romaji when there is no english title', () {
      final info = CanonicalInfo.fromAniList({
        'id': 1,
        'title': {'romaji': 'Kimetsu no Yaiba'},
        'genres': [],
      });

      expect(info.title, 'Kimetsu no Yaiba');
      expect(info.malId, isNull);
      expect(info.genres, isEmpty);
    });
  });

  group('AniListService', () {
    test('parses a search response and caches it', () async {
      var calls = 0;
      final client = MockClient((request) async {
        calls++;
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect((body['variables'] as Map)['search'], 'naruto');
        return http.Response(
          jsonEncode({
            'data': {
              'Media': {
                'id': 20,
                'idMal': 20,
                'title': {'romaji': 'NARUTO', 'english': 'Naruto'},
                'coverImage': {'large': 'c.jpg'},
                'description': 'ninja',
                'episodes': 220,
                'status': 'FINISHED',
                'genres': ['Action'],
              }
            }
          }),
          200,
        );
      });

      final service = AniListService(client: client);
      final first = await service.search('naruto');
      final second = await service.search('naruto');

      expect(first?.anilistId, 20);
      expect(second?.malId, 20);
      expect(calls, 1);
    });

    test('returns null on a non-200 response', () async {
      final service = AniListService(
        client: MockClient((_) async => http.Response('nope', 500)),
      );

      expect(await service.search('x'), isNull);
    });
  });
}
