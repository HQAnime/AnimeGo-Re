import 'package:html/dom.dart';

class AnimeInfo {
  String coverImage;
  String episode;
  String name;
  String link;

  AnimeInfo(Element e) {
    // Image class has image and also name, link but I will use name class instead
    final imageClass = e.getElementsByClassName('img')?.first;
    this.coverImage = imageClass?.nodes[1]?.nodes[1]?.attributes['src'];

    final episodeClass = e.getElementsByClassName('episode')?.first;
    this.episode = episodeClass?.nodes[0].text;

    final nameClass = e.getElementsByClassName('name')?.first;
    final nameLink = nameClass?.firstChild;
    this.name = nameLink?.attributes['title'];
    this.link = nameLink?.attributes['href'];
  }
}
