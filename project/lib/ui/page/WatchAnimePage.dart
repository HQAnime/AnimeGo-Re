import 'package:animego/core/Util.dart';
import 'package:animego/core/model/VideoServer.dart';
import 'package:animego/ui/interface/FullscreenPlayer.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// WatchAnimePage class
class WatchAnimePage extends StatefulWidget {
  const WatchAnimePage({
    Key? key,
    required this.video,
  }) : super(key: key);

  final VideoServer video;

  @override
  State<WatchAnimePage> createState() => _WatchAnimePageState();
}

class _WatchAnimePageState extends State<WatchAnimePage> with FullscreenPlayer {
  @override
  void initState() {
    // TODO: maybe toggle the native here???
    super.initState();
    setLandscape();
  }

  @override
  void dispose() {
    resetOrientation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Util.isIOS()
          ? AppBar(
              title: Text(widget.video.title ?? ''),
            )
          : null,
      body: WebView(
        initialUrl: widget.video.link,
        javascriptMode: JavascriptMode.unrestricted,
        initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
        navigationDelegate: (request) async {
          if (widget.video.link != null) {
            if (!request.url.contains(widget.video.link!)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          } else {
            return NavigationDecision.prevent;
          }
        },
      ),
    );
  }
}
