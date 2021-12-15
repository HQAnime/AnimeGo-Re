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
    this.player = Player(
      id: 123456,
      // pass the referer link to the player
      commandlineArguments: ['--http-referrer="${widget.refererLink}"'],
    );

    this.player.open(Media.network(widget.videoLink));

    print('player.open: ${widget.videoLink}');
    print('player.open: ${widget.refererLink}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VLC Player'),
      ),
      body: Video(
        player: player,
        height: 1080.0,
        width: 1920.0,
        scale: 1.0, // default
        showControls: true, // default
      ),
    );
  }
}
