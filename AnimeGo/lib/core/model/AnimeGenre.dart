class AnimeGenre {
  String _name;
  getAnimeGenreName() => _name;
  /// Merge domain name and formatted name
  getFullLink() {
    final formattedName = _name.split(' ').join('-');
    return '/genre/$formattedName';
  }

  AnimeGenre(this._name);
}
