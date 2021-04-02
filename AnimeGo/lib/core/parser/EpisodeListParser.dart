import 'package:AnimeGo/core/model/EpisodeSection.dart';
import 'package:AnimeGo/core/model/EpisodelInfo.dart';
import 'package:AnimeGo/core/parser/BasicParser.dart';
import 'package:html/dom.dart';

class EpisodeListParser extends BasicParser {
  // a valid link, http://gogoanimee.net//load-list-episode?ep_start=0&ep_end=23&id=8634&default_ep=0
  EpisodeListParser(String link, this.section)
      : super(link + section.getLink());

  final EpisodeSection section;

  @override
  List<EpisodeInfo> parseHTML(Document body) {
    List<EpisodeInfo> list = [];
    final episodeClass = body.getElementById('episode_related');
    // It starts from the latest (reversed) but it might be a good idea
    episodeClass.nodes.forEach((element) {
      if (element.runtimeType == Element) {
        list.add(EpisodeInfo(element));
      }
    });

    return list;
  }
}
