import 'package:AnimeGo/core/model/AnimeInfo.dart';
import 'package:flutter/material.dart';

/// AnimeDetailPage class
class AnimeDetailPage extends StatefulWidget {
  final AnimeInfo info;
  AnimeDetailPage({Key key, @required this.info}) : super(key: key);

  @override
  _AnimeDetailPageState createState() => _AnimeDetailPageState();
}


class _AnimeDetailPageState extends State<AnimeDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.info.getTitle())
      ),
      body: Center(
        child: Text('Anime Detail'),
      ),
    );
  }
}
