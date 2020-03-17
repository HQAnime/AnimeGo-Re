import 'package:flutter/material.dart';

/// SearchAnime class
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
        title: Expanded(
          child: TextField(
            style: TextStyle(color: Colors.white, fontSize: 20),
            decoration: InputDecoration.collapsed(
              hintText: 'Search anime',
              hintStyle: TextStyle(color: Colors.white70, fontSize: 20),
            ),
            autocorrect: false,
            autofocus: true,
            onChanged: (t) {},
          ),
        )
      ),
      body: Container(),
    );
  }
}
