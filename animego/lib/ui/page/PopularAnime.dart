import 'package:animego/ui/widget/AnimeGrid.dart';
import 'package:flutter/material.dart';

/// PopularAnime class
class PopularAnime extends StatelessWidget {
  const PopularAnime({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Popular')),
      body: AnimeGrid(url: '/popular.html'),
    );
  }
}