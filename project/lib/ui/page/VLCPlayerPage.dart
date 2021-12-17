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
    // pass the referer link to the player
    commandlineArguments: [
      '--http-referrer="${widget.refererLink}"',
      '--verbose=2',
    ],
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      player.open(Media.network('https://www.youtube.com/watch?v=S1iSJMXTkPU'));
      player.play();
    });

    print('player.open: ${widget.videoLink}');
    print('player.open: ${widget.refererLink}');
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

// ./VLC --verbose=2 --no-http-forward-cookies --http-referrer="https://en.gogoanimes.tv//platinum-end-episode-11" "https://www15.anicdn.stream/videos/hls/ZvWZSd-ZX-yuL6x0hqKg3Q/1639722726/176510/cefc259685d4189c9854211967ac53fd/ep.11.1639690732.m3u8"
