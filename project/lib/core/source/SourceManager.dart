import 'package:animego/core/model/AnimeDetailedInfo.dart';
import 'package:animego/core/model/BasicAnime.dart';
import 'package:animego/core/source/AnimeSource.dart';
import 'package:animego/core/source/anilist/AniListService.dart';
import 'package:animego/core/source/gogoanime/GogoanimeSource.dart';
import 'package:animego/core/source/hianime/AniwatchSource.dart';
import 'package:animego/core/source/hianime/HianimeSource.dart';
import 'package:animego/core/source/miruro/MiruroSource.dart';
import 'package:animego/core/source/nyaa/NyaaSource.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds every registered [AnimeSource] and tracks which one is active.
///
/// The active source is persisted so the user's choice survives restarts.
class SourceManager {
  static const prefsKey = 'AnimeGo:Source';
  static const _domainPrefix = 'AnimeGo:Domain:';

  SourceManager._();
  static final SourceManager _instance = SourceManager._();
  factory SourceManager() => _instance;

  /// Fired whenever the active source changes so the UI can rebuild.
  static final ValueNotifier<String> activeNotifier = ValueNotifier('');

  final Map<String, AnimeSource> _sources = {};
  String? _activeId;

  List<AnimeSource> get sources =>
      _sources.values.toList(growable: false);

  AnimeSource get active =>
      _sources[_activeId] ?? _sources.values.first;

  String get activeId => active.id;

  AnimeSource? byId(String id) => _sources[id];

  void register(AnimeSource source) {
    _sources[source.id] = source;
  }

  /// Register the built in sources and restore the last active one.
  Future<void> init() async {
    if (_sources.isEmpty) {
      register(GogoanimeSource());
      register(HianimeSource());
      register(AniwatchSource());
      register(MiruroSource());
      register(NyaaSource());
    }

    final prefs = await SharedPreferences.getInstance();

    // Apply saved per-source domain overrides (mirrors rotate often).
    for (final source in _sources.values) {
      final saved = prefs.getString('$_domainPrefix${source.id}');
      if (saved != null) source.updateBaseUrl(saved);
    }

    final saved = prefs.getString(prefsKey);
    if (saved != null && _sources.containsKey(saved)) {
      _activeId = saved;
    } else {
      _activeId = _sources.keys.first;
    }
    activeNotifier.value = _activeId!;
  }

  /// Change the active source and persist the choice.
  Future<void> select(String id) async {
    if (!_sources.containsKey(id) || id == _activeId) return;
    _activeId = id;
    activeNotifier.value = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefsKey, id);
  }

  /// Override a source's base URL and persist it.
  Future<void> updateBaseUrl(String id, String url) async {
    final source = _sources[id];
    if (source == null || url.trim().isEmpty) return;
    source.updateBaseUrl(url);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_domainPrefix$id', url.trim());
  }

  /// Resolve a detail page, falling back to the other streaming sources when
  /// the active one is down or cannot find the anime.
  Future<AnimeDetailedInfo?> detailWithFallback(BasicAnime anime) async {
    final activeDetail = await active.detail(anime);
    if (activeDetail != null) return _enrich(activeDetail);

    final name = anime.name;
    if (name == null || name.isEmpty) return null;

    for (final source in _sources.values) {
      if (source.id == active.id ||
          source.isWebView ||
          source.kind != SourceKind.streaming) {
        continue;
      }
      try {
        final results = await source.search(name);
        if (results.isEmpty) continue;
        final detail = await source.detail(results.first);
        if (detail != null) return _enrich(detail);
      } catch (e) {
        // Try the next source.
      }
    }
    return null;
  }

  /// Fill the AniList/MAL ids and any missing metadata from AniList.
  Future<AnimeDetailedInfo> _enrich(AnimeDetailedInfo detail) async {
    if (detail.anilistId != null || detail.name == null) return detail;
    final canonical = await AniListService.instance.search(detail.name!);
    if (canonical == null) return detail;

    detail.anilistId = canonical.anilistId;
    detail.malId = canonical.malId;
    detail.image ??= canonical.coverImage;
    if (detail.summary == null || detail.summary!.isEmpty) {
      detail.summary = canonical.summary;
    }
    return detail;
  }
}
