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
  late Player player;

  @override
  void initState() {
    super.initState();
    player = Player(
      id: 123456,
      // pass the referer link to the player
      commandlineArguments: ['--http-referrer="${widget.refererLink}"'],
    );

    player.open(
      Media.network(widget.videoLink),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VLC Player'),
      ),
      body: Video(
        player: player,
        height: 1920.0,
        width: 1080.0,
        scale: 1.0, // default
        showControls: false, // default
      ),
    );
  }
}
