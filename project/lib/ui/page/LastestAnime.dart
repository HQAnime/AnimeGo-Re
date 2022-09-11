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
        title: const Text('New Release'),
        actions: const [
          // IconButton(
          //   icon: Icon(Icons.refresh),
          //   onPressed: () {

          //   },
          // ),
        ],
      ),
      body: const AnimeGrid(
        url: '/page-recent-release.html',
      ),
      drawer: const AnimeDrawer(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () => Navigator.push(
          context,
          Util.platformPageRoute(
            builder: (context) => const SearchAnime(),
            fullscreenDialog: true,
          ),
        ),
      ),
    );
  }
}
