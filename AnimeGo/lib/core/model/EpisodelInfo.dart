import 'package:AnimeGo/core/model/BasicAnime.dart';
import 'package:html/dom.dart';

class EpisodeInfo extends BasicAnime {
  EpisodeInfo(Element e) : super.fromJson(null) {
    final node = e.nodes[0];
    this.name = node.nodes[1].text.trim();
    this.link = node.attributes['href'].trim();
  }
}
