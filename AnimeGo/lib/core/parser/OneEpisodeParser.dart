import 'package:AnimeGo/core/parser/BasicParser.dart';
import 'package:html/dom.dart';

/// This parses `VideoServer` and some other info for a `single` episode
class OneEpisodeParser extends BasicParser {
  OneEpisodeParser(String link) : super(link);

  @override
  parseHTML(Document body) {
    throw UnimplementedError();
  }
}
