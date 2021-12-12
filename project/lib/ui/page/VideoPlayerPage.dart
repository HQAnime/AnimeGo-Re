import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VidePlayerPage extends StatefulWidget {
  const VidePlayerPage({
    Key? key,
    required this.refererLink,
    required this.videoLink,
  }) : super(key: key);

  final String refererLink;
  final String videoLink;

  @override
  _VidePlayerPageState createState() => _VidePlayerPageState();
}

/// Code is referenced from
/// https://github.com/GeekyAnts/flick-video-player/blob/master/example/lib/default_player/default_player.dart

class _VidePlayerPageState extends State<VidePlayerPage> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    print(widget.refererLink);
    print(widget.videoLink);

    /// Based on https://github.com/pystardust/ani-cli/blob/1a1909b1f7bced503cd9173e433d9a712eae137c/ani-cli#L280
    /// Referer is needed in order to play the video properly
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(
        widget.videoLink,
        httpHeaders: {'Referer': widget.refererLink},
      ),
      autoPlay: true,
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: FlickVideoPlayer(
        flickManager: flickManager,
        flickVideoWithControls: FlickVideoWithControls(
          controls: FlickPortraitControls(),
        ),
        flickVideoWithControlsFullscreen: FlickVideoWithControls(
          controls: FlickLandscapeControls(),
        ),
      ),
    );
  }
}
