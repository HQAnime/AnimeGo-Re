import 'package:animego/core/source/AnimeSource.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;

/// Parses the torrent table on `nyaa.si`.
///
/// Each row looks like:
/// `category | name | links | size | date | seeders | leechers | downloads`
class NyaaParser {
  NyaaParser._();

  static List<TorrentRelease> parse(String html) {
    final doc = html_parser.parse(html);
    final rows = doc.querySelectorAll('table.torrent-list tbody tr');
    final list = <TorrentRelease>[];
    for (final row in rows) {
      final release = _parseRow(row);
      if (release != null) list.add(release);
    }
    return list;
  }

  static TorrentRelease? _parseRow(Element row) {
    final cells = row.children.where((e) => e.localName == 'td').toList();
    if (cells.length < 8) return null;

    final nameAnchor = cells[1].querySelector('a');
    final magnet =
        cells[2].querySelector('a[href^="magnet:"]')?.attributes['href'];
    final title =
        nameAnchor?.attributes['title']?.trim() ?? nameAnchor?.text.trim();
    if (title == null || title.isEmpty || magnet == null) return null;

    return TorrentRelease(
      title: title,
      magnet: magnet,
      size: cells[3].text.trim(),
      seeders: int.tryParse(cells[5].text.trim()),
      leechers: int.tryParse(cells[6].text.trim()),
    );
  }
}
