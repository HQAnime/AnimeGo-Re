/// The parent of some models in order to share info
class BasicAnime {
  String? name;
  String? link;

  BasicAnime(this.name, this.link);

  BasicAnime.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;
    name = json['name'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'link': link,
    };
  }

  @override
  String toString() {
    return 'name: $name, link: $link';
  }

  bool get isEpisode {
    return link?.contains('episode') ?? false;
  }

  bool get isCategory {
    return link?.contains('category') ?? false;
  }
}
