/// The parent of some models in order to share info
class BasicAnime {
  String? name;
  String? link;

  BasicAnime(this.name, this.link);

  BasicAnime.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;
    this.name = json['name'];
    this.link = json['link'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'link': this.link,
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
