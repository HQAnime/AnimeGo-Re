import 'package:animego/core/source/hianime/HianimeParser.dart';
import 'package:flutter_test/flutter_test.dart';

const _card = '''
<div class="flw-item flw-item-big">
  <div class="film-poster">
    <div class="tick ltr">
      <div class="tick-item tick-sub"><i class="fas fa-closed-captioning mr-1"></i>220</div>
      <div class="tick-item tick-dub"><i class="fas fa-microphone mr-1"></i>220</div>
      <div class="tick-item tick-eps">220</div>
    </div>
    <img src="https://cdn.example/naruto.jpg" class="film-poster-img" alt="Naruto">
    <a href="https://hianime.tr/watch/naruto-1335" class="film-poster-ahref item-qtip" data-id="1335"></a>
  </div>
  <div class="film-detail">
    <h3 class="film-name">
      <a href="https://hianime.tr/naruto-1335" title="Naruto" class="dynamic-name" data-jname="Naruto">Naruto</a>
    </h3>
  </div>
</div>
''';

const _detail = '''
<html>
<head>
  <meta name="hi-anime-id" content="1335">
</head>
<body>
  <div class="anis-content">
    <div class="anisc-poster">
      <div class="film-poster">
        <img src="https://hianime.tr/storage/media/naruto.webp" class="film-poster-img" alt="Naruto Poster">
      </div>
    </div>
    <div class="anisc-detail">
      <h2 class="film-name dynamic-name">Naruto</h2>
      <div class="film-stats"><div class="tick"><div class="tick-item tick-eps">220</div></div></div>
    </div>
    <div class="anisc-info-wrap">
      <div class="anisc-info">
        <div class="item item-title w-hide">
          <span class="item-head">Overview:</span>
          <div class="text">A hyperactive ninja.</div>
        </div>
        <div class="item item-title">
          <span class="item-head">Aired:</span>
          <span class="name">Oct 3, 2002 to Feb 8, 2007</span>
        </div>
        <div class="item item-title">
          <span class="item-head">Status:</span>
          <span class="name">Finished Airing</span>
        </div>
        <div class="item item-list">
          <span class="item-head">Genres:</span>
          <a href="https://hianime.tr/genres/action" title="Action">Action</a>
          <a href="https://hianime.tr/genres/fantasy" title="Fantasy">Fantasy</a>
        </div>
      </div>
    </div>
  </div>
</body>
</html>
''';

const _episodes = '''
<a title="Episode 1" class="ssl-item ep-item" data-number="1" data-id="22676" href="https://hianime.tr/watch/naruto-1335?ep=22676">
  <div class="ssli-order">1</div>
</a>
<a title="Episode 2" class="ssl-item ep-item" data-number="2" data-id="22677" href="https://hianime.tr/watch/naruto-1335?ep=22677">
  <div class="ssli-order">2</div>
</a>
''';

const _servers = '''
<div class="ps_-block ps_-block-sub servers-sub">
  <div class="ps__-list">
    <div class="item server-item" data-type="sub" data-server-name="ZokoAnime"
      data-hash="aHR0cHM6Ly96b2tvYW5pbWUudmlkZW8vc3RyZWFtL21hbC82MDk0OC8xL3N1Yg==">
      <a href="javascript:;" class="btn">ZokoAnime</a>
    </div>
  </div>
</div>
''';

void main() {
  group('HianimeParser.parseCards', () {
    test('parses name, link, cover and episode count', () {
      final cards = HianimeParser.parseCards(_card);

      expect(cards, hasLength(1));
      expect(cards.first.name, 'Naruto');
      expect(cards.first.link, '/naruto-1335');
      expect(cards.first.coverImage, 'https://cdn.example/naruto.jpg');
      expect(cards.first.episode, '220');
      expect(cards.first.detailed, isTrue);
      expect(cards.first.isCategory(), isTrue);
    });
  });

  group('HianimeParser.parseDetail', () {
    test('parses metadata and one episode section', () {
      final detail = HianimeParser.parseDetail(_detail);

      expect(detail, isNotNull);
      expect(detail!.name, 'Naruto');
      expect(detail.image, 'https://hianime.tr/storage/media/naruto.webp');
      expect(detail.summary, 'A hyperactive ninja.');
      expect(detail.released, 'Oct 3, 2002 to Feb 8, 2007');
      expect(detail.status, 'Finished Airing');
      expect(detail.lastEpisode, '220');
      expect(detail.genre.map((g) => g.getAnimeGenreName()),
          containsAll(['Action', 'Fantasy']));
      expect(detail.episodes, hasLength(1));
      expect(detail.episodes.first.payload, '1335');
    });

    test('returns null without an anime id', () {
      expect(
          HianimeParser.parseDetail('<html><body>nope</body></html>'), isNull);
    });
  });

  group('HianimeParser.parseEpisodes', () {
    test('parses episode id, number and link', () {
      final episodes = HianimeParser.parseEpisodes(_episodes);

      expect(episodes, hasLength(2));
      expect(episodes.first.name, 'Episode 1');
      expect(episodes.first.link, '/watch/naruto-1335?ep=22676&epnum=1');
    });
  });

  group('HianimeParser.parseServers', () {
    test('decodes the base64 embed url', () {
      final servers = HianimeParser.parseServers(_servers);

      expect(servers, hasLength(1));
      expect(
        servers.first.link,
        'https://zokoanime.video/stream/mal/60948/1/sub',
      );
      expect(servers.first.isEmbed, isTrue);
      expect(servers.first.title, contains('ZokoAnime'));
    });
  });

  group('animeIdFromSlug', () {
    test('extracts the trailing id', () {
      expect(HianimeParser.animeIdFromSlug('/watch/naruto-1335'), '1335');
      expect(
        HianimeParser.animeIdFromSlug('/reborn-as-a-space-mercenary-10499'),
        '10499',
      );
      expect(HianimeParser.animeIdFromSlug('/no-id-here'), isNull);
    });
  });
}
