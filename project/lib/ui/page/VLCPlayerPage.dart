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

// ./VLC --verbose=2 --http-referrer="https://www26.gogoanimes.tv/da-wang-rao-ming-episode-2" "https://www14.anicdn.stream/videos/hls/aahwFXUEiUYEvZU4gN-yng/1639560677/176349/a17b6a2874a24391926da09ecae20505/ep.2.1639533863.m3u8"
