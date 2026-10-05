import 'package:animego/core/http/CookieStore.dart';
import 'package:animego/core/native/NativeBridge.dart';

/// Solves the Cloudflare browser challenge for a source and remembers the
/// cookie so later HTTP requests can be made with plain Dart.
class CloudflareManager {
  CloudflareManager._();
  static final CloudflareManager _instance = CloudflareManager._();
  factory CloudflareManager() => _instance;

  final CookieStore store = CookieStore();

  /// Whether the native bypass is available on this platform.
  bool get isSupported => NativeBridge.isSupported;

  /// Open the challenge page for [url] and save the resulting cookie.
  ///
  /// Returns true when a cookie was captured. The native side only finishes
  /// once the challenge has passed (or it timed out), so a non-empty cookie is
  /// a good success signal.
  Future<bool> verify(
    String sourceId,
    String url, {
    bool dark = false,
  }) async {
    final result = await NativeBridge.getCookie(link: url, dark: dark);
    final cookie = result.isNotEmpty ? result[0] : '';
    final userAgent = result.length > 1 ? result[1] : '';
    if (cookie.isEmpty) return false;

    await store.save(
      sourceId,
      cookie: cookie,
      userAgent: userAgent.isEmpty ? CookieStore.defaultUserAgent : userAgent,
    );
    return true;
  }

  Future<bool> hasCookie(String sourceId) => store.hasCookieFor(sourceId);

  Future<void> clear(String sourceId) => store.clear(sourceId);
}
