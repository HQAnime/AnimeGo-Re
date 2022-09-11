import 'package:animego/core/Firebase.dart';
import 'package:animego/ui/widget/AnimeGrid.dart';
import 'package:flutter/material.dart';

/// PopularAnime class
class PopularAnime extends StatelessWidget {
  const PopularAnime({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseEventService().logUseEpisode();
    return Scaffold(
      appBar: AppBar(title: const Text('Popular')),
      body: const AnimeGrid(url: '/popular.html'),
    );
  }
}
