import 'package:animego/core/source/AnimeSource.dart';
import 'package:animego/core/web/WebViewScripts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _landscape = false;

  static const _rotations = <DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ];

  @override
  void initState() {
    super.initState();

    // Web sources play video inline, so let the device rotate freely.
    SystemChrome.setPreferredOrientations(_rotations);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..addJavaScriptChannel(
        'Flutter',
        onMessageReceived: _onJavaScriptMessage,
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) => setState(() => _progress = progress / 100),
          onPageFinished: (_) => _controller.runJavaScript(
            '${WebViewScripts.adBlock}\n${WebViewScripts.fullscreenReporter}',
          ),
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
  void dispose() {
    // Restore the default portrait-leaning rotation.
    SystemChrome.setPreferredOrientations(_rotations);
    super.dispose();
  }

  void _onJavaScriptMessage(JavaScriptMessage message) {
    if (message.message == 'fullscreen::true') {
      _rotate(true);
    } else if (message.message == 'fullscreen::false') {
      _rotate(false);
    }
  }

  /// Force landscape while a video is fullscreen, otherwise allow rotation.
  void _rotate(bool landscape) {
    if (!mounted || _landscape == landscape) return;
    setState(() => _landscape = landscape);
    SystemChrome.setPreferredOrientations(
      landscape
          ? const [
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ]
          : _rotations,
    );
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
          IconButton(
            tooltip: _landscape ? 'Portrait' : 'Landscape',
            icon: Icon(
              _landscape
                  ? Icons.stay_current_portrait
                  : Icons.stay_current_landscape,
            ),
            onPressed: () => _rotate(!_landscape),
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
