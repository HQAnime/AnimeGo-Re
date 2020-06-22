import 'package:AnimeGo/ui/page/SearchAnime.dart';
import 'package:AnimeGo/ui/widget/AnimeDrawer.dart';
import 'package:AnimeGo/ui/widget/AnimeGrid.dart';
import 'package:flutter/material.dart';

/// LastestAnime class, it loads anime from the new release page
class LastestAnime extends StatelessWidget {
  LastestAnime({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Release'),
      ),
      body: AnimeGrid(
        url: '/page-recent-release.html',
      ),
      drawer: AnimeDrawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SearchAnime(), fullscreenDialog: true)),
      ),
    );
  }
}
