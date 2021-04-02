import 'package:animego/core/model/BasicAnime.dart';
import 'package:html/dom.dart';

/// It has the info needed by AnimeGrid, it can either be `latest episode` or `an anime`
class AnimeInfo extends BasicAnime {
  String? coverImage;

  // Either episode or release
  String? episode = '???';
  bool isDUB = false;

  AnimeInfo(Element e) : super.fromJson(null) {
    // Image class has image and also name, link but I will use name class instead
    final imageClass = e.getElementsByClassName('img').first;
    this.coverImage = imageClass.nodes[1].nodes[1].attributes['src'];

    // In order to call isCategory(), link needs to be parsed first
    final nameClass = e.getElementsByClassName('name').first;
    final nameLink = nameClass.firstChild;
    this.name = nameLink?.attributes['title']!.trim();
    _formatAnimeName(name);
    this.link = nameLink?.attributes['href'];

    // Category has a released class while episode only has the episode
    if (isCategory()) {
      final releaseClass = e.getElementsByClassName('released').first;
      this.episode =
          releaseClass.nodes[0].text?.trim().replaceAll('Released: ', '');
    } else {
      final episodeClass = e.getElementsByClassName('episode').first;
      this.episode = episodeClass.nodes[0].text;
    }
  }

  /// Category contains all available episodes
  bool isCategory() => link?.contains('category') ?? false;

  /// Returns either episode or the name of name
  String? getTitle() {
    if (isCategory()) return this.name;
    return this.episode;
  }

  /// Some anime are DUB and I will put the name in the front
  void _formatAnimeName(String? name) {
    if (name != null && name.toLowerCase().contains("(dub)")) {
      // It is 100% that dub will be at the end
      isDUB = true;
      final component = name.split(' ')..removeLast();
      // remove extra spaces and append it to DUB
      this.name = '[Dub] ' + component.join(' ').trimRight();
    }
  }
}
