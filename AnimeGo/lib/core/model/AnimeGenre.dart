class AnimeGenre {
  String _name;
  getAnimeGenreName() => _name;
  /// Merge domain name and formatted name
  getFullLink() {
    return _name;
  }

  AnimeGenre(this._name);
}
