class AnimeGenre {
  final String? _name;
  String getAnimeGenreName() => _name ?? 'Unknown';

  /// Merge domain name and formatted name
  String getFullLink() {
    final formattedName = _name?.split(' ').join('-').toLowerCase() ?? '';
    return '/genre/$formattedName';
  }

  AnimeGenre(this._name);
}
