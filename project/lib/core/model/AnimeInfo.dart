import 'package:animego/core/model/BasicAnime.dart';

/// It has the info needed by AnimeGrid, it can either be `latest episode` or `an anime`
class AnimeInfo extends BasicAnime {
  String? coverImage;

  // Either episode or release
  String? episode = '??';
  bool isDUB = false;

  /// Whether this card points at an anime detail page (rather than straight
  /// to an episode). API based sources always set this.
  bool detailed = false;

  /// The only way to build a card; sources pass the fields they parsed.
  AnimeInfo.create({
    String? name,
    String? link,
    this.coverImage,
    this.episode = '??',
    this.isDUB = false,
    this.detailed = false,
  }) : super.fromJson(null) {
    this.name = name;
    this.link = link;
  }

  /// Category contains all available episodes
  bool isCategory() => detailed || (link?.contains('category') ?? false);

  /// Returns either episode or the name of name
  String? getTitle() {
    if (isCategory()) return this.name;
    return this.episode;
  }
}
