import 'package:AnimeGo/core/model/VideoServer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// WatchAnimePage class
class WatchAnimePage extends StatefulWidget {
  const WatchAnimePage({
    Key key,
    @required this.video,
  }) : super(key: key);

  final VideoServer video;

  @override
  _WatchAnimePageState createState() => _WatchAnimePageState();
}

class _WatchAnimePageState extends State<WatchAnimePage> {
  @override
  void initState() {
    // TODO: maybe toggle the native???
    super.initState();
    // Fullscreen mode
    SystemChrome.setEnabledSystemUIOverlays([]);
    // Landscape only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Reset UI overlay
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    // Reset orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: widget.video.link,
        initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
        navigationDelegate: (request) async {
          if (!request.url.contains(widget.video.link))
            return NavigationDecision.prevent;
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
