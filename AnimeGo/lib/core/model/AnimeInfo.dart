import 'package:html/dom.dart';

/// It has the info needed by AnimeGrid
class AnimeInfo {
  String coverImage;
  String name;
  String link;

  // Either episode or release
  String episode;
  String release;
  
  AnimeInfo(Element e) {
    // Image class has image and also name, link but I will use name class instead
    final imageClass = e.getElementsByClassName('img')?.first;
    this.coverImage = imageClass?.nodes[1]?.nodes[1]?.attributes['src'];

    try {      
      final episodeClass = e.getElementsByClassName('episode')?.first;
      this.episode = episodeClass?.nodes[0].text;
    } catch (e) { 
      print(e); 
    }

    try {
      final releaseClass = e.getElementsByClassName('released')?.first;
      this.episode = releaseClass?.nodes[0].text.trim();
    } catch (e) { 
      print(e); 
    }

    final nameClass = e.getElementsByClassName('name')?.first;
    final nameLink = nameClass?.firstChild;
    this.name = nameLink?.attributes['title'];
    this.link = nameLink?.attributes['href'];
  }
}
