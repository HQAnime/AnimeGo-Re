import 'package:AnimeGo/core/model/AnimeInfo.dart';
import 'package:AnimeGo/core/parser/BasicParser.dart';
import 'package:html/dom.dart';

/// This parses the grid gogoanime uses
class AnimeParser extends BasicParser {
  AnimeParser(String link) : super(link);

  @override
  List<AnimeInfo> parseHTML(Document body) {
    List<AnimeInfo> list = []; 

    if (body != null) {  
      final div = body.getElementsByClassName('items');
      // There should only one of the list
      if (div != null && div.length == 1) {
        final items = div.first;
        // check if items contains an error message
        if (!items.text.contains('Sorry')) {
          // It can be an empty list
          if (items.hasChildNodes()) {
            items.nodes.forEach((element) {
              // Only parse elements, no Text
              if (element.runtimeType == Element) {
                list.add(AnimeInfo(element));
              }
            });
          }
        } 
      }
    }

    return list;
  }
}