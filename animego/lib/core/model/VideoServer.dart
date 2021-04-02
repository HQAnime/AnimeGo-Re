import 'package:html/dom.dart';

class VideoServer {
  String? title;
  String? link;

  VideoServer(Element e) {
    final node = e.nodes[1];
    this.link = node.attributes['data-video'];
    this.title = node.nodes[0].text;
    // this.title = node.
  }
}
