import 'dart:io';

import 'package:AnimeGo/core/Util.dart';
import 'package:AnimeGo/core/model/VideoServer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// WatchAnimePage class
class WatchAnimePage extends StatefulWidget {
  final VideoServer video;
  WatchAnimePage({Key key, @required this.video}) : super(key: key);

  @override
  _WatchAnimePageState createState() => _WatchAnimePageState();
}


class _WatchAnimePageState extends State<WatchAnimePage> with SingleTickerProviderStateMixin {
  @override
  void initState() {
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
      appBar: Util.isIOS() ? AppBar(title: Text(widget.video.title)) : null,
      body: WebView(
        initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
        gestureNavigationEnabled: true,
        initialUrl: widget.video.link,
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest request) {
          if (!request.url.startsWith(widget.video.link)) {
            print('block $request');
            return NavigationDecision.prevent;
          }

          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
