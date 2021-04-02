/// Json model for update info
class GithubUpdate {
  final String? version;
  final String? newFeatures;
  final String? downloadLink;

  const GithubUpdate({this.version, this.newFeatures, this.downloadLink});

  factory GithubUpdate.fromJson(Map<String, dynamic>? json) {
    if (json == null) return GithubUpdate();
    return GithubUpdate(
      version: json['version'],
      newFeatures: json['new'],
      downloadLink: json['link'],
    );
  }
}
