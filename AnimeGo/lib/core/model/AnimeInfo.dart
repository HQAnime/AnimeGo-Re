import 'package:html/dom.dart';

/// It has the info needed by AnimeGrid, it can either be `latest episode` or `an anime`
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

    // Category has a released class while episode only has the episode
    if (isCategory()) {
      final releaseClass = e.getElementsByClassName('released')?.first;
      this.episode = releaseClass?.nodes[0].text.trim().replaceAll('Released: ', '');
    } else {
      final episodeClass = e.getElementsByClassName('episode')?.first;
      this.episode = episodeClass?.nodes[0].text;
    }

    final nameClass = e.getElementsByClassName('name')?.first;
    final nameLink = nameClass?.firstChild;
    this.name = nameLink?.attributes['title'];
    this.link = nameLink?.attributes['href'];
  }

  /// Category contains all available episodes
  isCategory() => link.contains('category');

  /// Returns either episode or the name of name
  getTitle() {
    if (isCategory()) return this.name;
    return this.episode;
  }
}
