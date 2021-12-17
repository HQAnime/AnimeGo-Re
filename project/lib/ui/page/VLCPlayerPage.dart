import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';

class VLCPlayerPage extends StatefulWidget {
  const VLCPlayerPage({
    Key? key,
    required this.refererLink,
    required this.videoLink,
  }) : super(key: key);

  final String refererLink;
  final String videoLink;

  @override
  _VLCPlayerPageState createState() => _VLCPlayerPageState();
}

class _VLCPlayerPageState extends State<VLCPlayerPage> {
  late final Player player = Player(
    id: 123456,
    commandlineArguments: [
      // pass the referer link to the player as authentication
      '--http-referrer="${widget.refererLink}"',
      // Use regular HTTP modules (default disabled)
      // Connect using HTTP access instead of custom HTTP code
      // This is the secret for playing
      '--adaptive-use-access',
    ],
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final media = Media.network(
        // use 720p to play
        widget.videoLink,
        parse: true,
      );

      player.open(media);
    });

    print('video: ${widget.videoLink}');
    print('referer: ${widget.refererLink}');
  }

  @override
  void dispose() {
    this.player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VLC Player'),
      ),
      body: Video(
        player: player,
      ),
    );
  }
}

// ./VLC --verbose=2 --http-referrer="https://en.gogoanimes.tv//platinum-end-episode-11" "https://www15.anicdn.stream/videos/hls/ZvWZSd-ZX-yuL6x0hqKg3Q/1639722726/176510/cefc259685d4189c9854211967ac53fd/ep.11.1639690732.m3u8"
