import 'package:AnimeGo/core/model/VideoServer.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// WatchAnimePage class
class WatchAnimePage extends StatefulWidget {
  final VideoServer video;
  WatchAnimePage({Key key, @required this.video}) : super(key: key);

  @override
  _WatchAnimePageState createState() => _WatchAnimePageState();
}


class _WatchAnimePageState extends State<WatchAnimePage> {
  bool showAppBar = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          AnimatedOpacity(
            duration: Duration(microseconds: 300),
            opacity: showAppBar ? 1 : 0,
            child: AppBar(
              title: Text(widget.video.title)
            ),
          ),
          WebView(
            initialUrl: widget.video.link,
          ),
        ],
      ),
    );
  }
}
