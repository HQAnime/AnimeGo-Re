import 'package:animego/core/Firebase.dart';
import 'package:animego/core/Global.dart';
import 'package:animego/ui/page/AnimeDetailPage.dart';
import 'package:flutter/material.dart';

/// Favourite class
class Favourite extends StatelessWidget {
  const Favourite({
    Key? key,
    this.showAppBar = true,
  }) : super(key: key);

  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    FirebaseEventService().logUseFavouriteList();
    final list = Global().favouriteList;
    return Scaffold(
      appBar: showAppBar ? AppBar(title: Text('Favourite Anime')) : null,
      body: list.length > 0
          ? ListView.builder(
              itemCount: list.length,
              itemBuilder: (c, i) {
                final curr = list[i];
                return ListTile(
                  title: Text(curr?.name ?? 'Unknown'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => AnimeDetailPage(info: curr),
                      ),
                    );
                  },
                );
              },
            )
          : Center(child: Text('No anime found')),
    );
  }
}
