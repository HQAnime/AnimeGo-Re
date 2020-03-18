import 'package:AnimeGo/core/model/AnimeInfo.dart';
import 'package:flutter/material.dart';

/// EpisodePage class
class EpisodePage extends StatefulWidget {
  AnimeInfo info;
  EpisodePage({Key key, @required this.info}) : super(key: key);

  @override
  _EpisodePageState createState() => _EpisodePageState();
}


class _EpisodePageState extends State<EpisodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.info.getTitle())
      ),
      body: Container(),
    );
  }
}
