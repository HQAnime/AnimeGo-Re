import 'dart:io';

import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher_string.dart';

enum NativePlayerType { vlc }

class NativePlayer {
  final _logger = Logger('NativePlayer');
  final String? referrer;
  final String? link;

  NativePlayer({
    required this.link,
    this.referrer,
  });

  void play() async {
    final link = this.link ?? '';
    try {
      await Process.run(_getCommand(NativePlayerType.vlc), [
        '--http-referrer="$referrer"',
        '--adaptive-use-access',
        '--http-user-agent=Mozilla/5.0',
        link,
      ]);
    } catch (e) {
      _logger.severe(e);
      // simply launch with the default broswer here
      launchUrlString(link);
    }
  }

  /// Get command depending on current system
  String _getCommand(NativePlayerType type) {
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
