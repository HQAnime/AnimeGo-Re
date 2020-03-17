class Genre {
  String _name;
  getGenreName() => _name;
  /// Merge domain name and formatted name
  getFullLink() {
    return _name;
  }

  Genre(this._name);
}