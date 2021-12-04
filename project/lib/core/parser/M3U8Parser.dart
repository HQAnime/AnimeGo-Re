import 'package:animego/core/parser/BasicParser.dart';
import 'package:html/dom.dart';

/// This parses the m3u8 link from the html
class M3U8Parser extends BasicParser {
  M3U8Parser(
    String link,
  ) : super(link);

  @override
  String? parseHTML(Document? body) {
    final content = body?.getElementsByClassName('videocontent').first;
    if (content != null) {
      final script = content.text;
      final regex = RegExp(r"sources:\[{file: .(.*)\.m3u8'");
      final m3u8Link = regex.firstMatch(script)?.group(1);
      if (m3u8Link != null) {
        return m3u8Link + '.m3u8';
      }
    }

    return null;
  }
}
