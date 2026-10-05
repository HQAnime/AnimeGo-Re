import 'package:animego/core/source/nyaa/NyaaParser.dart';
import 'package:flutter_test/flutter_test.dart';

const _table = '''
<table class="table table-bordered table-hover table-striped torrent-list">
  <thead><tr><th></th></tr></thead>
  <tbody>
    <tr class="success">
      <td><a href="/?c=1_2" title="Anime - English-translated"><img src="/x.png" class="category-icon"></a></td>
      <td colspan="2"><a href="/view/2166966" title="[AnoZu] One Piece S23E25 1080p">[AnoZu] One Piece S23E25 1080p</a></td>
      <td class="text-center">
        <a href="/download/2166966.torrent"><i class="fa fa-download"></i></a>
        <a href="magnet:?xt=urn:btih:8cf49ef107cd1d8f1a097092edf7afef9c4d147c&amp;dn=One%20Piece"><i class="fa fa-magnet"></i></a>
      </td>
      <td class="text-center">1.3 GiB</td>
      <td class="text-center" data-timestamp="1790525021">2026-09-27 16:03</td>
      <td class="text-center">1303</td>
      <td class="text-center">9</td>
      <td class="text-center">7959</td>
    </tr>
    <tr class="default">
      <td><a href="/?c=1_2" title="Anime"><img src="/x.png"></a></td>
      <td colspan="2"><a href="/view/1" title="No magnet release">No magnet release</a></td>
      <td class="text-center"><a href="/download/1.torrent"><i></i></a></td>
      <td class="text-center">700 MiB</td>
      <td class="text-center">2026-09-01</td>
      <td class="text-center">5</td>
      <td class="text-center">0</td>
      <td class="text-center">10</td>
    </tr>
  </tbody>
</table>
''';

void main() {
  group('NyaaParser.parse', () {
    test('parses title, magnet, size and peer counts', () {
      final releases = NyaaParser.parse(_table);

      expect(releases, hasLength(1));
      expect(releases.first.title, '[AnoZu] One Piece S23E25 1080p');
      expect(
        releases.first.magnet,
        contains('magnet:?xt=urn:btih:8cf49ef107cd1d8f1a097092edf7afef9c4d147c'),
      );
      expect(releases.first.size, '1.3 GiB');
      expect(releases.first.seeders, 1303);
      expect(releases.first.leechers, 9);
    });

    test('skips rows without a magnet link', () {
      final releases = NyaaParser.parse(_table);

      expect(releases.map((r) => r.title), isNot(contains('No magnet release')));
    });

    test('ignores the comments link in the name cell', () {
      const withComments = '''
<table class="torrent-list"><tbody>
  <tr>
    <td><a href="/?c=1_2">Anime</a></td>
    <td>
      <a class="comments" href="/view/99#comments" title="1 comment">1</a>
      <a href="/view/99" title="[Group] Real Title">[Group] Real Title</a>
    </td>
    <td><a href="magnet:?xt=urn:btih:abc">m</a></td>
    <td>1.0 GiB</td>
    <td>2026-01-01</td>
    <td>10</td>
    <td>1</td>
    <td>3</td>
  </tr>
</tbody></table>
''';

      final releases = NyaaParser.parse(withComments);

      expect(releases, hasLength(1));
      expect(releases.first.title, '[Group] Real Title');
    });
  });
}
