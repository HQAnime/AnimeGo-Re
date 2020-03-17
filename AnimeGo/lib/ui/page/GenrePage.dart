import 'package:AnimeGo/core/model/Genre.dart';
import 'package:AnimeGo/ui/widget/AnimeGrid.dart';
import 'package:flutter/material.dart';

/// GenrePage class
class GenrePage extends StatelessWidget {
  final Genre genre;
  GenrePage({Key key, @required this.genre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimeGrid(
        title: genre.getGenreName(), 
        url: genre.getFullLink()
      ),
    );
  }
}
