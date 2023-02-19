import 'package:animego/core/Util.dart';
import 'package:animego/core/model/VideoServer.dart';
import 'package:animego/ui/interface/FullscreenPlayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
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
  final _logger = Logger('WatchAnimePage');
  int count = 0;

  late final link = widget.video.link;
  late final _webController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
        NavigationDelegate(onNavigationRequest: (request) async {
      // enter fullscreen
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [],
      );

      if (count == 0) {
        // the first one should be allowed to load
        count++;
        return NavigationDecision.navigate;
      }

      _logger.info(request.url);
      if (link != null) {
        if (!request.url.contains(link as Pattern)) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      } else {
        return NavigationDecision.prevent;
      }
    }))
    ..loadRequest(Uri.parse(link ?? ''));

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
    _logger.info(link);

    return Scaffold(
      appBar: Util.isIOS()
          ? AppBar(
              title: Text(widget.video.title ?? ''),
            )
          : null,
      body: SafeArea(
        child: WebViewWidget(
          controller: _webController,
        ),
      ),
    );
  }
}
