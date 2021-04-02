import 'package:animego/core/model/AnimeGenre.dart';
import 'package:animego/ui/widget/AnimeGrid.dart';
import 'package:flutter/material.dart';

/// AnimeGenrePage class
class GenrePage extends StatelessWidget {
  const GenrePage({
    Key? key,
    required this.genre,
  }) : super(key: key);

  final AnimeGenre genre;

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
