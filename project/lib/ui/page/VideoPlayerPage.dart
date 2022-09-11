import 'package:animego/core/Util.dart';
import 'package:animego/ui/interface/FullscreenPlayer.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({
    Key? key,
    required this.videoLink,
    this.refererLink,
    this.title,
  }) : super(key: key);

  final String? refererLink;
  final String? videoLink;
  final String? title;

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

/// Code is referenced from
/// https://github.com/GeekyAnts/flick-video-player/blob/master/example/lib/default_player/default_player.dart

class _VideoPlayerPageState extends State<VideoPlayerPage>
    with FullscreenPlayer {
  final _logger = Logger('VideoPlayerPage');
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    _logger.info(widget.refererLink);
    _logger.info(widget.videoLink);

    /// Based on https://github.com/pystardust/ani-cli/blob/1a1909b1f7bced503cd9173e433d9a712eae137c/ani-cli#L280
    /// Referer is needed in order to play the video properly
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(
        widget.videoLink!,
        httpHeaders: {
          'Referer': widget.refererLink ?? '',
          'User-Agent': 'Mozilla/5.0',
        },
      ),
      autoPlay: true,
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    // the player doesn't reset the orientation
    resetOrientation();
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Util.isIOS()
          ? AppBar(
              title: Text(widget.title ?? 'Video Player'),
            )
          : null,
      body: SafeArea(
        child: FlickVideoPlayer(
          flickManager: flickManager,
          // force landscape
          preferredDeviceOrientation: const [
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ],
          flickVideoWithControls: const FlickVideoWithControls(
            videoFit: BoxFit.contain,
            controls: FlickPortraitControls(),
          ),
          flickVideoWithControlsFullscreen: const FlickVideoWithControls(
            videoFit: BoxFit.contain,
            controls: FlickLandscapeControls(),
          ),
        ),
      ),
    );
  }
}
