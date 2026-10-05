import 'package:animego/core/source/AnimeSource.dart';
import 'package:animego/core/source/SourceManager.dart';
import 'package:animego/ui/page/SearchAnime.dart';
import 'package:animego/ui/page/WebSourcePage.dart';
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
    return ValueListenableBuilder<String>(
      valueListenable: SourceManager.activeNotifier,
      builder: (context, activeId, child) {
        final source = SourceManager().active;
        return Scaffold(
          appBar: AppBar(
            title: Text(source.isWebView ? source.name : 'New Release'),
          ),
          body: source.isWebView
              ? WebSourcePage(key: ValueKey(activeId), source: source)
              : AnimeGrid(
                  key: ValueKey(activeId),
                  loadPage: (page) =>
                      source.browse(BrowseKind.latest, page: page),
                ),
          drawer: AnimeDrawer(),
          floatingActionButton: source.isWebView
              ? null
              : FloatingActionButton(
                  child: Icon(Icons.search),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchAnime(),
                      fullscreenDialog: true,
                    ),
                  ),
                ),
        );
      },
    );
  }
}
