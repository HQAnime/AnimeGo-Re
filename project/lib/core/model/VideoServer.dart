class VideoServer {
  String? title;
  String? link;

  /// Whether [link] is a full player/embed page that should be opened as-is
  /// (as opposed to a link that still needs to find the video).
  bool isEmbed;

  /// The only way to build a server; sources pass the resolved link.
  VideoServer.create({this.title, this.link, this.isEmbed = false});
}
