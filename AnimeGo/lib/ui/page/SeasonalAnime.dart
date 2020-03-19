import 'package:AnimeGo/ui/widget/AnimeGrid.dart';
import 'package:flutter/material.dart';

/// SeasonalAnime class
class SeasonalAnime extends StatelessWidget {
  SeasonalAnime({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Season')
      ),
      body: AnimeGrid(url: '/new-season.html'),
    );
  }

}
