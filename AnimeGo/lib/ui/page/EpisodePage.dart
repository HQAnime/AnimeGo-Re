import 'package:AnimeGo/core/Global.dart';
import 'package:AnimeGo/core/model/AnimeInfo.dart';
import 'package:AnimeGo/core/model/OneEpisodeInfo.dart';
import 'package:AnimeGo/core/parser/OneEpisodeParser.dart';
import 'package:flutter/material.dart';

/// EpisodePage class
class EpisodePage extends StatefulWidget {
  final AnimeInfo info;
  EpisodePage({Key key, @required this.info}) : super(key: key);

  @override
  _EpisodePageState createState() => _EpisodePageState();
}


class _EpisodePageState extends State<EpisodePage> {
  OneEpisodeInfo info;
  final global = Global();
  
  @override
  void initState() {
    super.initState();
    final parser = OneEpisodeParser(global.getDomain() + widget.info.link);
    parser.downloadHTML().then((body) {
      this.info = parser.parseHTML(body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.info.getTitle())
      ),
      body: Center(
        child: Text('Episode'),
      ),
    );
  }
}
