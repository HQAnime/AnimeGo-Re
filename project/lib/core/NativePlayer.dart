import 'dart:io';

import 'package:animego/core/Util.dart';

enum NativePlayerType { VLC, MPV }

class NativePlayer {
  final String referrer;
  final String link;

  NativePlayer({
    required this.link,
    required this.referrer,
  });

  play(NativePlayerType type) {
    switch (type) {
      case NativePlayerType.VLC:
        Process.run('vlc', [
          '--http-referrer="${referrer}"',
          '--adaptive-use-access',
          link,
        ]);
        break;
      default:
        break;
    }
  }
}
