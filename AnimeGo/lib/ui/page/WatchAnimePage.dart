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
  bool renderFAB = false;

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
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          setState(() {
            renderFAB = !renderFAB;
            if (renderFAB) {
              Future.delayed(Duration(seconds: 2)).then((value) {
                setState(() {
                  renderFAB = false;
                });
              });
            }
          });
        },
        child: FractionallySizedBox(
          heightFactor: 1.0,
          child: WebView(
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
        ),
      ),
      floatingActionButton: renderFAB ? 
      FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          child: Icon(Icons.close),
      ) : 
      null
    );
  }
}
