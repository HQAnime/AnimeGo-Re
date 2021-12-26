import 'package:animego/core/Util.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// PRIVACY POLICY
/// April 3, 2021
///
/// AnimeGo (starting form version 1.3.0) logs some user events via Firebase. The data is used for analytics purposes.
/// No personal data is collected as you can see from `_logSimpleEvent` method. Only `true` is sent.
/// All data are anonymous. Please see https://firebase.google.com/policies/analytics/ for Firebase's privacy policy.
///
/// If you have any concerns, please contact the developer via email.
///
class FirebaseEventService {
  final analytics = FirebaseAnalytics();

  void _logEvent(String name, Map<String, String> parameters) {
    if (Util.isMobile()) {
      analytics.logEvent(name: name, parameters: parameters);
    }
  }

  void _logSimpleEvent(String name) {
    // Only 'true' is passed to the developer here, nothing else
    _logEvent(name, {name: 'true'});
  }

  void logUseAnimeInfo() {
    _logSimpleEvent('anime_info');
  }

  void logUseCategory() {
    _logSimpleEvent('category');
  }

  void logUseEpisode() {
    _logSimpleEvent('episode');
  }

  void logUseEpisodeList() {
    _logSimpleEvent('episode_list');
  }

  void logFabMenu() {
    _logSimpleEvent('fab_menu');
  }

  void logUseFavouriteList() {
    _logSimpleEvent('favourite_list');
  }

  void logUseGenre() {
    _logSimpleEvent('genre');
  }

  void logUseGoogle() {
    _logSimpleEvent('google_anime');
  }

  void logUseHistoryList() {
    _logSimpleEvent('history');
  }

  void logUseMovie() {
    _logSimpleEvent('movie');
  }

  void logUsePopular() {
    _logSimpleEvent('popular');
  }

  void logUseSearch() {
    _logSimpleEvent('search');
  }

  void logUseSeasonal() {
    _logSimpleEvent('seasonal');
  }

  void logUseSettings() {
    _logSimpleEvent('settings');
  }

  void logUseFavourite() {
    _logSimpleEvent('toggle_favourite');
  }

  void logWatchInApp() {
    _logSimpleEvent('watch_in_app');
  }

  void logWatchWithOthers() {
    _logSimpleEvent('watch_with_others');
  }
}
