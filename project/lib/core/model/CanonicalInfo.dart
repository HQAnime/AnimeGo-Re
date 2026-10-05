/// Canonical anime metadata resolved from AniList.
///
/// Sources speak different ids; AniList (and MAL) ids are the common language
/// used to recognise the same anime across them and to enrich thin metadata.
class CanonicalInfo {
  final int anilistId;
  final int? malId;
  final String? title;
  final String? coverImage;
  final String? summary;
  final int? episodes;
  final String? status;
  final List<String> genres;

  const CanonicalInfo({
    required this.anilistId,
    this.malId,
    this.title,
    this.coverImage,
    this.summary,
    this.episodes,
    this.status,
    this.genres = const [],
  });

  factory CanonicalInfo.fromAniList(Map<String, dynamic> media) {
    final title = media['title'] as Map<String, dynamic>?;
    final cover = media['coverImage'] as Map<String, dynamic>?;
    return CanonicalInfo(
      anilistId: media['id'] as int,
      malId: media['idMal'] as int?,
      title: (title?['english'] ?? title?['romaji']) as String?,
      coverImage: cover?['large'] as String?,
      summary: media['description'] as String?,
      episodes: media['episodes'] as int?,
      status: media['status'] as String?,
      genres:
          (media['genres'] as List?)?.whereType<String>().toList() ?? const [],
    );
  }
}
