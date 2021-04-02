import 'package:animego/core/model/OneEpisodeInfo.dart';
import 'package:animego/core/parser/BasicParser.dart';
import 'package:html/dom.dart';

/// This parses `VideoServer` and some other info for a `single` episode
class OneEpisodeParser extends BasicParser {
  OneEpisodeParser(String link) : super(link);

  @override
  OneEpisodeInfo parseHTML(Document? body) {
    final div = body?.getElementsByClassName('anime_video_body');
    return OneEpisodeInfo(div?.first);
  }
}
