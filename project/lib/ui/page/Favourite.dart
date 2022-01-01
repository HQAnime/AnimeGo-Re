import 'package:animego/core/Firebase.dart';
import 'package:animego/core/Global.dart';
import 'package:animego/core/Util.dart';
import 'package:animego/ui/interface/Embeddable.dart';
import 'package:animego/ui/page/AnimeDetailPage.dart';
import 'package:flutter/material.dart';

/// Favourite class
class Favourite extends StatelessWidget implements Embeddable {
  const Favourite({
    Key? key,
    this.embedded = false,
  }) : super(key: key);

  final bool embedded;

  @override
  Widget build(BuildContext context) {
    FirebaseEventService().logUseFavouriteList();
    final list = Global().favouriteList;
    return Scaffold(
      appBar: embedded ? null : AppBar(title: Text('Favourite Anime')),
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
                      Util.platformPageRoute(
                        builder: (c) => AnimeDetailPage(info: curr),
                      ),
                    );
                  },
                );
              },
            )
          : Center(
              child: Text('No anime found'),
            ),
    );
  }
}
