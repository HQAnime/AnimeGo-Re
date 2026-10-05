import 'package:animego/core/model/BasicAnime.dart';
import 'package:html/dom.dart';

class EpisodeInfo extends BasicAnime {
  /// Build without parsing HTML, used by API based sources.
  EpisodeInfo.create({String? name, String? link}) : super.fromJson(null) {
    this.name = name;
    this.link = link;
  }

  EpisodeInfo(Element e) : super.fromJson(null) {
    final node = e.nodes[0];
    this.name = node.nodes[1].text?.trim();
    this.link = node.attributes['href']?.trim();
  }
}
