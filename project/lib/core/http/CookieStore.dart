import 'package:shared_preferences/shared_preferences.dart';

/// Persists the Cloudflare cookie and user agent for each source.
///
/// The user agent must match the one the native WebView used, otherwise the
/// cookie is rejected.
class CookieStore {
  CookieStore._();
  static final CookieStore _instance = CookieStore._();
  factory CookieStore() => _instance;

  static const _cookiePrefix = 'AnimeGo:Cookie:';
  static const _userAgentPrefix = 'AnimeGo:UserAgent:';

  /// A common desktop Chrome agent used before a WebView has saved one.
  static const defaultUserAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36';

  String _cookieKey(String sourceId) => '$_cookiePrefix$sourceId';
  String _userAgentKey(String sourceId) => '$_userAgentPrefix$sourceId';

  Future<String> cookieFor(String sourceId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cookieKey(sourceId)) ?? '';
  }

  Future<String> userAgentFor(String sourceId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userAgentKey(sourceId)) ?? defaultUserAgent;
  }

  Future<bool> hasCookieFor(String sourceId) async {
    return (await cookieFor(sourceId)).isNotEmpty;
  }

  Future<void> save(
    String sourceId, {
    required String cookie,
    required String userAgent,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cookieKey(sourceId), cookie);
    await prefs.setString(_userAgentKey(sourceId), userAgent);
  }

  Future<void> clear(String sourceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cookieKey(sourceId));
    await prefs.remove(_userAgentKey(sourceId));
  }
}
