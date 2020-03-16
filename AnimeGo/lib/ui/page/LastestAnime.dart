import 'package:flutter/material.dart';

/// LastestAnime class, it loads anime from the new release page
class LastestAnime extends StatefulWidget {
  LastestAnime({Key key}) : super(key: key);

  @override
  _LastestAnimeState createState() => _LastestAnimeState();
}

class _LastestAnimeState extends State<LastestAnime> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Release')
      ),
      body: Container(),
    );
  }
}
