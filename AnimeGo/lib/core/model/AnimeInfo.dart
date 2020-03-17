import 'package:html/dom.dart';

/// It has the info needed by AnimeGrid
class AnimeInfo {
  String coverImage;
  String name;
  String link;

  // Either episode or release
  String episode = '???';
  
  AnimeInfo(Element e) {
    // Image class has image and also name, link but I will use name class instead
    final imageClass = e.getElementsByClassName('img')?.first;
    this.coverImage = imageClass?.nodes[1]?.nodes[1]?.attributes['src'];

    final episodeClass = e.getElementsByClassName('episode');
    if (episodeClass.length > 0) {
      this.episode = episodeClass?.first?.nodes[0].text;
    }

    final releaseClass = e.getElementsByClassName('released');
    if (releaseClass.length > 0) {
      this.episode = releaseClass?.first?.nodes[0].text.trim();
    }

    final nameClass = e.getElementsByClassName('name')?.first;
    final nameLink = nameClass?.firstChild;
    this.name = nameLink?.attributes['title'];
    this.link = nameLink?.attributes['href'];
  }
}
