class AnimeGenre {
  String _name;
  String getAnimeGenreName() => _name;
  /// Merge domain name and formatted name
  getFullLink() {
    final formattedName = _name.split(' ').join('-').toLowerCase();
    return '/genre/$formattedName';
  }

  AnimeGenre(this._name);
}
