import 'package:html/dom.dart';

class VideoServer {
  String? title;
  String? link;

  /// Whether [link] is a full player/embed page that should be opened as-is
  /// (as opposed to a gogoanime page that still needs to find the video).
  bool isEmbed;

  /// Build without parsing HTML, used by API based sources.
  VideoServer.create({this.title, this.link, this.isEmbed = false});

  VideoServer(Element e) : isEmbed = false {
    final node = e.nodes[1];

    // Fix link with https
    var link1 = node.attributes['data-video'] ?? '';
    if (!link1.startsWith('http')) {
      link1 = 'https://$link1';
    }
    this.link = link1;

    // Get the title
    final title1 = node.nodes[1].text ?? '';
    if (title1.trim().isEmpty) {
      this.title = node.nodes[2].text?.toUpperCase();
    } else {
      this.title = title1.toUpperCase();
    }
  }
}
