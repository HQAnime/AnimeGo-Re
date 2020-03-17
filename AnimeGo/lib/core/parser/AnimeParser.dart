import 'package:AnimeGo/core/parser/BasicParser.dart';
import 'package:html/dom.dart';

/// This parses the grid gogoanime uses
class AnimeParser extends BasicParser {
  AnimeParser(String link) : super(link);

  @override
  parseHTML(Document body) {
    print(body);
  }
}