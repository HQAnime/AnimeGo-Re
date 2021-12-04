import 'package:html/dom.dart';

class VideoServer {
  String? title;
  String? link;

  VideoServer(Element e) {
    final node = e.nodes[1];

    // Fix link with https
    var link1 = node.attributes['data-video'] ?? '';
    if (!link1.startsWith('http')) {
      link1 = 'https://' + link1;
    }
    // we have //// in the link and must be removed
    this.link = link1.replaceFirst('////', '//');

    // Get the title
    final title1 = node.nodes[0].text ?? '';
    if (title1.trim().isEmpty) {
      this.title = node.nodes[2].text?.toUpperCase();
    } else {
      this.title = title1.toUpperCase();
    }
  }
}
