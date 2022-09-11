import 'package:animego/core/model/MP4Info.dart';
import 'package:animego/core/parser/BasicParser.dart';
import 'package:html/dom.dart';

/// This parses mp4 links from the html, 360P, 480P, 720P, 1080P
class MP4Parser extends BasicParser {
  MP4Parser(
    String link,
  ) : super(link);

  @override
  List<MP4Info>? parseHTML(Document? body) {
    // there are two mirror links but the first one is actual MP4s
    try {
      final content = body?.getElementsByClassName('mirror_link').first;
      if (content != null) {
        // this is a typo from the website
        final downloads = content.getElementsByClassName('dowload');
        List<MP4Info> mp4s = [];
        for (final d in downloads) {
          final link = d.firstChild?.attributes['href'];
          final description = d.text.replaceAll('  ', '').split('\n');
          var name = '';
          // we need the second one and the first should be `Download`
          if (description.length > 1 && description[0] == 'Download') {
            // (360P - MP4) -> 360P
            name = description[1].split(' - ').first.replaceFirst('(', '');
          }

          // The referrer is now needed to download or stream the video
          mp4s.add(MP4Info(name, link, getLink()));
        }

        return mp4s;
      }
    } catch (e) {
      return null;
    }
  }
}
