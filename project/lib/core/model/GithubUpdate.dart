/// Json model for update info
class GithubUpdate {
  const GithubUpdate({
    this.version,
    this.newFeatures,
    this.downloadLink,
  });

  final String? version;
  final String? newFeatures;
  final String? downloadLink;

  factory GithubUpdate.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const GithubUpdate();
    return GithubUpdate(
      version: json['version'],
      newFeatures: json['new'],
      downloadLink: json['link'],
    );
  }
}
