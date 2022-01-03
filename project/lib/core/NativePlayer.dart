import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

enum NativePlayerType { VLC }

class NativePlayer {
  final String? referrer;
  final String? link;

  NativePlayer({
    required this.link,
    this.referrer,
  });

  play() async {
    final link = this.link ?? '';
    try {
      await Process.runSync(_getCommand(NativePlayerType.VLC), [
        '--http-referrer="${referrer}"',
        '--adaptive-use-access',
        link,
      ]);
    } catch (e) {
      print(e);
      // simply launch with the default broswer here
      launch(link);
    }
  }

  /// Get command depending on current system
  _getCommand(NativePlayerType type) {
    if (Platform.isLinux) {
      return 'vlc';
    } else if (Platform.isMacOS) {
      return '/Applications/VLC.app/Contents/MacOS/VLC';
    } else if (Platform.isWindows) {
      return 'C:\\Program Files\\VideoLAN\\VLC\\vlc.exe';
    } else {
      return 'vlc';
    }
  }
}
