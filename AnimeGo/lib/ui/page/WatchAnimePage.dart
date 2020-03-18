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
      body: Stack(
        children: <Widget>[
          WebView(
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
          GestureDetector(
            onHorizontalDragEnd: (d) {
              final offset = d.velocity.pixelsPerSecond;
              // Only swipe to the right
              if (offset.dx > 0) {
                setState(() {
                  this.renderFAB = !renderFAB;
                  if (renderFAB) {
                    // auto hide after 2 seconds
                    Future.delayed(Duration(milliseconds: 2300)).then((value) {
                      setState(() {
                        this.renderFAB = false;
                      });
                    });
                  }
                });
              }
            },
          ),
        ],
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
