import 'dart:async';
import 'dart:convert';

import 'package:animego/core/http/CookieStore.dart';
import 'package:http/http.dart' as http;

/// A small HTTP wrapper that sends the stored Cloudflare cookie and user agent
/// with every request, and flags blocked responses.
class RequestService {
  RequestService({
    required this.sourceId,
    required this.baseUrl,
    this.extraHeaders = const {},
    this.timeout = const Duration(seconds: 10),
  });

  /// The source this service belongs to, used to look up its cookie.
  final String sourceId;

  /// Base URL used to resolve relative paths and as the referer.
  final String baseUrl;

  /// Source specific headers (e.g. `x-requested-with`).
  final Map<String, String> extraHeaders;

  final Duration timeout;

  Future<Map<String, String>> _headers(Map<String, String>? headers) async {
    final cookie = await CookieStore().cookieFor(sourceId);
    final userAgent = await CookieStore().userAgentFor(sourceId);
    return <String, String>{
      'user-agent': userAgent,
      if (cookie.isNotEmpty) 'cookie': cookie,
      'accept': 'text/html,application/xhtml+xml,application/json;q=0.9,*/*;q=0.8',
      'accept-language': 'en-US,en;q=0.9',
      'referer': baseUrl,
      ...extraHeaders,
      ...?headers,
    };
  }

  String resolve(String path) {
    if (path.startsWith('http')) return path;
    return '$baseUrl$path';
  }

  Future<http.Response?> get(
    String path, {
    Map<String, String>? headers,
  }) async {
    try {
      return await http
          .get(Uri.parse(resolve(path)), headers: await _headers(headers))
          .timeout(timeout);
    } catch (e) {
      print('RequestService.get $path failed: $e');
      return null;
    }
  }

  Future<http.Response?> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    try {
      return await http
          .post(
            Uri.parse(resolve(path)),
            headers: await _headers(headers),
            body: body,
            encoding: encoding,
          )
          .timeout(timeout);
    } catch (e) {
      print('RequestService.post $path failed: $e');
      return null;
    }
  }

  /// Whether the response looks like a Cloudflare / anti-bot block.
  static bool isBlocked(http.Response? response) {
    if (response == null) return false;
    const blocked = [401, 403, 429, 503];
    return blocked.contains(response.statusCode);
  }

  /// Whether the response is a successful HTML/JSON response.
  static bool isOk(http.Response? response) =>
      response != null && response.statusCode == 200;
}
