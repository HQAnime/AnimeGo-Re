import 'package:animego/core/source/AnimeSource.dart';
import 'package:animego/core/web/WebViewScripts.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Embeds a web-only [AnimeSource] (e.g. Miruro) in a WebView.
///
/// No scraping happens here: the site is loaded as-is, its own JavaScript
/// player is used, and [WebViewScripts.adBlock] strips pop-ups and ads. This
/// is deliberately the same approach the app used to take for playback.
class WebSourcePage extends StatefulWidget {
  const WebSourcePage({
    Key? key,
    required this.source,
  }) : super(key: key);

  final AnimeSource source;

  @override
  _WebSourcePageState createState() => _WebSourcePageState();
}

class _WebSourcePageState extends State<WebSourcePage> {
  late final WebViewController _controller;
  double _progress = 0;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) => setState(() => _progress = progress / 100),
          onPageFinished: (_) => _controller.runJavaScript(WebViewScripts.adBlock),
          onNavigationRequest: (request) {
            // Keep browsing inside the web source. External apps are left to
            // the player links instead of hijacking navigation.
            if (request.url.startsWith('http')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.source.webHomeUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(child: WebViewWidget(controller: _controller)),
        _buildControls(),
      ],
    );
  }

  Widget _buildControls() {
    if (_progress < 1) {
      return LinearProgressIndicator(value: _progress == 0 ? null : _progress);
    }
    return SafeArea(
      top: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            tooltip: 'Back',
            icon: Icon(Icons.arrow_back),
            onPressed: () => _goBack(),
          ),
          IconButton(
            tooltip: 'Forward',
            icon: Icon(Icons.arrow_forward),
            onPressed: () async {
              if (await _controller.canGoForward()) {
                await _controller.goForward();
              }
            },
          ),
          IconButton(
            tooltip: 'Home',
            icon: Icon(Icons.home),
            onPressed: () =>
                _controller.loadRequest(Uri.parse(widget.source.webHomeUrl)),
          ),
          IconButton(
            tooltip: 'Reload',
            icon: Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
    );
  }

  Future<void> _goBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
    }
  }
}
