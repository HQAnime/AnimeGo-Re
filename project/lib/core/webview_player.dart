// A desktop only webview player similar to the mobile one
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

class WebViewPlayer {
  final _logger = Logger('WebViewPlayer');
  final String _link;

  WebViewPlayer(this._link);

  Future<bool> play() async {
    // make sure the link starts with https: and also add front and back quotes
    String link = _link;
    if (_link.startsWith('//')) {
      link = 'https:' + link;
    }

    if (Platform.isMacOS) {
      _logger.info('Playing $link on macOS');
      // use the native channel
      final channel = MethodChannel('AnimeGo');
      final result = await channel.invokeMethod('webview_player', link);
      return result;
    }

    link = '"$link"';
    _logger.info('Playing $_link');
    final pwd = await Process.run('pwd', []);
    _logger.info('pwd: ${pwd.stdout}');

    // get current app path
    final appPath = Platform.script.toFilePath();
    _logger.info('appPath: $appPath');

    final webview = await Process.run('./webview_rust', ['"$_link"']);
    _logger.info(webview.stdout);
    return webview.exitCode == 0;
  }
}
