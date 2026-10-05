import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Thin wrapper around the platform channel implemented natively.
///
/// The native side opens a real WebView, solves the Cloudflare challenge and
/// returns `[cookie, userAgent]`.
class NativeBridge {
  NativeBridge._();

  static const MethodChannel _channel =
      MethodChannel('com.yihengquan.gogoanime');

  /// The bypass is only implemented on Android for now.
  static bool get isSupported => !kIsWeb && Platform.isAndroid;

  /// Runs the browser check for [link] and returns `[cookie, userAgent]`.
  ///
  /// Both entries are empty when the platform is unsupported or the user
  /// cancelled the challenge.
  static Future<List<String>> getCookie({
    required String link,
    bool dark = false,
  }) async {
    if (!isSupported) return const ['', ''];
    try {
      final result = await _channel.invokeMethod<List<dynamic>>(
        'getCookie',
        <String, dynamic>{'link': link, 'dark': dark},
      );
      if (result == null) return const ['', ''];
      return result.map((entry) => entry?.toString() ?? '').toList();
    } catch (e) {
      print('NativeBridge.getCookie failed: $e');
      return const ['', ''];
    }
  }
}
