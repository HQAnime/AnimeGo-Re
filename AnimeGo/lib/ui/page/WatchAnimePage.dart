import 'package:AnimeGo/core/model/VideoServer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

/// WatchAnimePage class
class WatchAnimePage extends StatefulWidget {
  final VideoServer video;
  WatchAnimePage({Key key, @required this.video}) : super(key: key);

  @override
  _WatchAnimePageState createState() => _WatchAnimePageState();
}


class _WatchAnimePageState extends State<WatchAnimePage> {
  bool showAppBar = true;
  final flutterWebViewPlugin = FlutterWebviewPlugin();

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
          WebviewScaffold(
            url: widget.video.link
          ),
        ],
      ),
    );
  }
}
