import 'package:animego/core/source/AnimeSource.dart';
import 'package:animego/core/source/gogoanime/GogoanimeSource.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds every registered [AnimeSource] and tracks which one is active.
///
/// The active source is persisted so the user's choice survives restarts.
class SourceManager {
  static const prefsKey = 'AnimeGo:Source';

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
    }

    final prefs = await SharedPreferences.getInstance();
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
}
