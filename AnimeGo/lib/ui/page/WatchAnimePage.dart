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


class _WatchAnimePageState extends State<WatchAnimePage> {
  double closeOpacity = 0;

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
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          WebView(
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
            onTap: () {
              setState(() {
                closeOpacity = closeOpacity == 0 ? 1 : 0;
              });
            },
          ),
        ],
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: closeOpacity, 
        duration: Duration(microseconds: 1000),
        child: FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          child: Icon(Icons.close),
        ),
      ),
    );
  }
}
