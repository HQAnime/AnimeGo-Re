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

  play(NativePlayerType type) async {
    switch (type) {
      case NativePlayerType.VLC:
        final output = await Process.runSync('vlc', [
          '--http-referrer="${referrer}"',
          '--adaptive-use-access',
          link,
        ]);

        print(output.stderr);
        print(output.stdout);
        break;
      default:
        break;
    }
  }
}
