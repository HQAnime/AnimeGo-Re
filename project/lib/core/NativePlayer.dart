import 'dart:io';

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
        final output = await Process.runSync(_getCommand(type), [
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

  /// Get command depending on current system
  _getCommand(NativePlayerType type) {
    if (Platform.isLinux) {
      return 'vlc';
    } else if (Platform.isMacOS) {
      return '/Applications/VLC.app/Contents/MacOS/VLC';
    } else if (Platform.isWindows) {
      return 'cmd';
    } else {
      return 'vlc';
    }
  }
}
