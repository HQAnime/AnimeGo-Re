import 'package:AnimeGo/core/model/AnimeGenre.dart';
import 'package:AnimeGo/ui/widget/AnimeGrid.dart';
import 'package:flutter/material.dart';

/// AnimeGenrePage class
class GenrePage extends StatelessWidget {
  final AnimeGenre genre;
  GenrePage({Key key, @required this.genre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(genre.getAnimeGenreName()),
      ),
      body: AnimeGrid(url: genre.getFullLink()),
    );
  }
}
