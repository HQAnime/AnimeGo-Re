import 'package:animego/core/Firebase.dart';
import 'package:animego/ui/widget/AnimeGrid.dart';
import 'package:flutter/material.dart';

/// Movie class
class Movie extends StatelessWidget {
  const Movie({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseEventService().logUseMovie();
    return Scaffold(
      appBar: AppBar(title: Text('Movie')),
      body: AnimeGrid(url: '/anime-movies.html'),
    );
  }
}
