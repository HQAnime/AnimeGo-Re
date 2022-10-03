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
      final channel = MethodChannel('AnimeGo');
      final result = await channel.invokeMethod('webview_player', link);
      assert(result != null, 'Failed to play $link');
      return result;
    }

    if (Platform.isWindows) {
      // get the path of the executable
      String path = Platform.resolvedExecutable;
      _logger.info('Path: $path');
      // remove the executable name
      path = path.substring(0, path.lastIndexOf('\\'));
      _logger.info('Path: $path');
      final result = await Process.run(
        'webview_rust.exe',
        [link],
        workingDirectory: path,
      );
      return result.exitCode == 0;
    }

    return false;
  }
}
