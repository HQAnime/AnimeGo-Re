// import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';

@Deprecated('dart_vlc is no longer used due to its potential memory')
class VLCPlayerPage extends StatefulWidget {
  const VLCPlayerPage({
    Key? key,
    required this.refererLink,
    required this.videoLink,
  }) : super(key: key);

  final String refererLink;
  final String videoLink;

  @override
  State<VLCPlayerPage> createState() => _VLCPlayerPageState();
}

class _VLCPlayerPageState extends State<VLCPlayerPage> {
  // late final Player player = Player(
  //   id: 123456,
  //   commandlineArguments: [
  //     // pass the referer link to the player as authentication
  //     '--http-referrer="${widget.refererLink}"',
  //     // Use regular HTTP modules (default disabled)
  //     // Connect using HTTP access instead of custom HTTP code
  //     // This is the secret for playing
  //     '--adaptive-use-access',
  //   ],
  // );

  bool fixedVideo = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final media = Media.network(
      //   // use 720p to play
      //   widget.videoLink,
      //   parse: true,
      // );

      // player.open(media, autoStart: true);

      // player.positionStream.listen((PositionState state) {
      //   if (!fixedVideo && (state.position?.inSeconds ?? 0) > 0) {
      //     fixedVideo = true;
      //     // this will fix the video issue, don't know why
      //     player.pause();
      //     player.play();
      //   }
      // });
    });

    print('video: ${widget.videoLink}');
    print('referer: ${widget.refererLink}');
  }

  @override
  void dispose() {
    // player.stop();
    // player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VLC Player'),
      ),
      // body: Video(
      //   player: player,
      // ),
    );
  }
}
