import 'package:AnimeGo/ui/widget/AnimeDrawer.dart';
import 'package:AnimeGo/ui/widget/AnimeGrid.dart';
import 'package:flutter/material.dart';

/// LastestAnime class, it loads anime from the new release page
class LastestAnime extends StatelessWidget {
  LastestAnime({Key key}) : super(key: key);

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
