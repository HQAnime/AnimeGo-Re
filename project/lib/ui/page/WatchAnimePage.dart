import 'dart:convert';

import 'package:animego/core/Util.dart';
import 'package:animego/core/model/VideoServer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// WatchAnimePage class
class WatchAnimePage extends StatefulWidget {
  const WatchAnimePage({
    Key? key,
    required this.video,
  }) : super(key: key);

  final VideoServer video;

  @override
  _WatchAnimePageState createState() => _WatchAnimePageState();
}

class _WatchAnimePageState extends State<WatchAnimePage> {
  bool _isLoading = true;
  late final _controller = WebViewController();

  void _setupWebViewController() {
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (request) async {
          if (widget.video.link != null) {
            if (!request.url.contains(widget.video.link!))
              return NavigationDecision.prevent;
            return NavigationDecision.navigate;
          } else
            return NavigationDecision.prevent;
        },
        onPageFinished: (url) async {
          // inject our js script
          await _controller.runJavaScript(_JS_SCRIPT);
        },
      ))
      ..addJavaScriptChannel(
        "Flutter",
        onMessageReceived: (JavaScriptMessage message) {
          final data = jsonDecode(message.message);
          print("From webview: $data");
        },
      )
      ..loadRequest(Uri.parse(widget.video.link ?? ''));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: maybe toggle the native here???
    super.initState();
    // Fullscreen mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    // Landscape only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _setupWebViewController();
  }

  @override
  void dispose() {
    // Reset UI overlay
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
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
      appBar: Util.isIOS()
          ? AppBar(
              title: Text(widget.video.title ?? ''),
            )
          : null,
      body: _isLoading
          ? Container()
          : WebViewWidget(
              controller: _controller,
            ),
    );
  }
}

const _JS_SCRIPT = """
    // a wrapper to send messages to the flutter side
    function send_flutter(...args) {
        Flutter.postMessage(JSON.stringify(args));
    }
  
    // macOS needs some additional work to fullscreen the video
    var has_seen_video = false;
    var has_setup = false;

    // remove iframes and check for video src
    setInterval(function() {
        const iframes = document.querySelectorAll('iframe');
        iframes.forEach(function(iframe) {
            iframe.remove();
            removed_iframe_count += 1;
            send_flutter('iframe removed');
        });
        
        if (!has_setup) {
            send_flutter('Setup');
            has_setup = true;
        }
        
        if (has_seen_video) {
            return;
        }

        send_flutter('tick');

        const videos = document.querySelectorAll('video');
        if (videos && videos.length > 0) {
            const the_video = videos[0];
            const video_src = the_video.src;
            if (video_src != "") {
                send_flutter("getting video src");
                has_seen_video = true;

                // this event is only required on macOS
                the_video.click();
                the_video.play();
            } else {
                send_flutter("trying to play video");
                // play and pause the video to get the src
                the_video.click()
                the_video.play();
                setTimeout(() => {
                    the_video.pause();
                }, 1000);
            }
        }
    }, 100);

    const valid_video_extensions = [".m3u8", ".ts", ".jpg", ".svg", ".ico", ".css", ".tff", ".vtt", ".srt", ".html", ".woff", ".js"];
    const valid_url_string = ["/ep."];
    source_url = window.location.href;

    // block unnecessary requests
    XMLHttpRequest.prototype.orgOpen = XMLHttpRequest.prototype.open;
    XMLHttpRequest.prototype.open = function(method, url, async, user, password) {
        send_flutter(method, url, async, user, password);

        // we haven't find the video yet
        if (!has_seen_video) {
            // always allow before we find the video
            send_flutter("Allowed");
            this.orgOpen.apply(this, arguments);
            return;
        }

        // apply very strict rules once the video starts playing
        // check if the url is a video and allow it
        if (valid_video_extensions.some((ext) => url.endsWith(ext)) || valid_url_string.some((str) => url.includes(str))) {
            send_flutter('Streaming');
            has_seen_video = true;
            this.orgOpen.apply(this, arguments);
            return;
        };

        send_flutter("Blocked");
    };

    // block popups
    window.open = function() { send_flutter('Disabled popup') };

    // remove all href links to prevent going to another page
    document.addEventListener('DOMContentLoaded', function() {
        const links = document.querySelectorAll('[href]');
        links.forEach(function(link) {
            link.href = 'javascript:void(0)';
        });
    });

    // styling changes
    document.body.style.backgroundColor = "black";
""";
