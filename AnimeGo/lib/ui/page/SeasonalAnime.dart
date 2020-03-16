import 'package:flutter/material.dart';

/// SeasonalAnime class
class SeasonalAnime extends StatefulWidget {
  SeasonalAnime({Key key}) : super(key: key);

  @override
  _SeasonalAnimeState createState() => _SeasonalAnimeState();
}


class _SeasonalAnimeState extends State<SeasonalAnime> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SeasonalAnime')
      ),
      body: Container(),
    );
  }
}
