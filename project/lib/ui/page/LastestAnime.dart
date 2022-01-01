import 'package:animego/core/Util.dart';
import 'package:animego/ui/page/SearchAnime.dart';
import 'package:animego/ui/widget/AnimeDrawer.dart';
import 'package:animego/ui/widget/AnimeGrid.dart';
import 'package:flutter/material.dart';

/// LastestAnime class, it loads anime from the new release page
class LastestAnime extends StatelessWidget {
  const LastestAnime({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Release'),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.refresh),
          //   onPressed: () {

          //   },
          // ),
        ],
      ),
      body: AnimeGrid(
        url: '/page-recent-release.html',
      ),
      drawer: AnimeDrawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () => Navigator.push(
          context,
          Util.platformPageRoute(
            builder: (context) => SearchAnime(),
            fullscreenDialog: true,
          ),
        ),
      ),
    );
  }
}
