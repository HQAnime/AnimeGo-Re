import 'package:AnimeGo/ui/widget/AnimeDrawer.dart';
import 'package:AnimeGo/ui/widget/AnimeGrid.dart';
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
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: Text('New Release'),
        ),
        body: AnimeGrid(url: ''),
        drawer: AnimeDrawer(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: () {},
        ),
      ),
    );
  }
}
