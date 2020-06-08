import 'package:AnimeGo/core/Global.dart';
import 'package:AnimeGo/ui/page/AnimeDetailPage.dart';
import 'package:flutter/material.dart';

/// Favourite class
class Favourite extends StatelessWidget {
  final bool showAppBar;
  Favourite({Key key, this.showAppBar = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = Global().favouriteList;
    return Scaffold(
      appBar: showAppBar ? AppBar(
        title: Text('Favourite Anime')
      ) : null,
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (c, i) {
          final curr = list[i];
          return ListTile(
            title: Text(curr.name),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) => AnimeDetailPage(info: curr)));
            },
          );
        },
      ),
    );
  }
}
