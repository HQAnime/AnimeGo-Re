import 'package:flutter/material.dart';

/// SearchAnime class, it has a search bar and also displays lots of chips to select genres
class SearchAnime extends StatefulWidget {
  SearchAnime({Key key}) : super(key: key);

  @override
  _SearchAnimeState createState() => _SearchAnimeState();
}

class _SearchAnimeState extends State<SearchAnime> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search')
      ),
      body: Container(),
    );
  }
}
