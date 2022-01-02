import 'package:animego/core/model/AnimeInfo.dart';
import 'package:animego/core/model/BasicAnime.dart';
import 'package:animego/ui/page/AnimeDetailPage.dart';
import 'package:animego/ui/page/EpisodePage.dart';
import 'package:flutter/material.dart';

/// A combination of AnimeDetail and Episode page
class TabletAnimePage extends StatefulWidget {
  const TabletAnimePage({
    Key? key,
    required this.info,
  }) : super(key: key);

  final BasicAnime info;

  @override
  _TabletAnimePageState createState() => _TabletAnimePageState();
}

class _TabletAnimePageState extends State<TabletAnimePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Flexible(
            flex: 1,
            child: AnimeDetailPage(
              info: widget.info,
              embedded: true,
            ),
          ),
          Flexible(
            flex: 1,
            child: EpisodePage(
              info: widget.info,
              embedded: true,
            ),
          ),
        ],
      ),
    );
  }
}
