import 'package:animego/core/model/AnimeDetailedInfo.dart';
import 'package:animego/core/model/AnimeGenre.dart';
import 'package:animego/core/model/AnimeInfo.dart';
import 'package:animego/core/model/EpisodeSection.dart';
import 'package:animego/core/model/EpisodelInfo.dart';
import 'package:animego/core/model/OneEpisodeInfo.dart';
import 'package:animego/core/model/VideoServer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnimeInfo.create', () {
    test('populates the fields', () {
      final info = AnimeInfo.create(
        name: 'Naruto',
        link: '/naruto',
        coverImage: 'cover.jpg',
        episode: '12',
        isDUB: true,
      );

      expect(info.name, 'Naruto');
      expect(info.link, '/naruto');
      expect(info.coverImage, 'cover.jpg');
      expect(info.episode, '12');
      expect(info.isDUB, isTrue);
    });

    test('defaults episode and dub', () {
      final info = AnimeInfo.create(name: 'Bleach', link: '/bleach');

      expect(info.episode, '??');
      expect(info.isDUB, isFalse);
    });
  });

  group('AnimeDetailedInfo.create', () {
    test('keeps the provided collections', () {
      final genres = [AnimeGenre('Action')];
      final sections = [
        EpisodeSection.create(
          episodeStart: '1',
          episodeEnd: '12',
          payload: '?id=1',
        ),
      ];

      final detail = AnimeDetailedInfo.create(
        name: 'Naruto',
        genre: genres,
        episodes: sections,
        lastEpisode: '12',
      );

      expect(detail.genre, genres);
      expect(detail.episodes, sections);
      expect(detail.lastEpisode, '12');
    });
  });

  group('EpisodeSection', () {
    test('getLink returns the payload', () {
      final section = EpisodeSection.create(payload: '?id=42');

      expect(section.getLink(), '?id=42');
    });

    test('getLink is empty when no payload is set', () {
      final section = EpisodeSection.create();

      expect(section.getLink(), '');
    });
  });

  group('EpisodeInfo.create', () {
    test('populates name and link', () {
      final episode = EpisodeInfo.create(name: 'Episode 1', link: '/ep-1');

      expect(episode.name, 'Episode 1');
      expect(episode.link, '/ep-1');
    });
  });

  group('VideoServer.create', () {
    test('populates title and link', () {
      final server = VideoServer.create(title: 'VidStreaming', link: '//x/y');

      expect(server.title, 'VidStreaming');
      expect(server.link, '//x/y');
    });
  });

  group('OneEpisodeInfo.create', () {
    test('populates fields and servers', () {
      final server = VideoServer.create(title: 'VidStreaming', link: '//x/y');
      final info = OneEpisodeInfo.create(
        name: 'Naruto',
        link: '/naruto-ep-1',
        currentEpisode: '1',
        currentEpisodeLink: '/naruto-ep-1',
        servers: [server],
      );

      expect(info.name, 'Naruto');
      expect(info.currentEpisode, '1');
      expect(info.servers, [server]);
    });
  });
}
