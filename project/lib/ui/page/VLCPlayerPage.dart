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

  bool fixedVideo = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final media = Media.network(
        // use 720p to play
        widget.videoLink,
        parse: true,
      );

      player.open(media, autoStart: true);

      player.positionStream.listen((PositionState state) {
        if (!fixedVideo && (state.position?.inSeconds ?? 0) > 0) {
          fixedVideo = true;
          // this will fix the video issue, don't know why
          player.pause();
          player.play();
        }
      });
    });

    print('video: ${widget.videoLink}');
    print('referer: ${widget.refererLink}');
  }

  @override
  void dispose() {
    player.stop();
    player.dispose();
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
