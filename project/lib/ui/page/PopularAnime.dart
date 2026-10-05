import 'package:animego/core/source/AnimeSource.dart';
import 'package:animego/core/source/SourceManager.dart';
import 'package:animego/ui/widget/AnimeGrid.dart';
import 'package:flutter/material.dart';

/// PopularAnime class
class PopularAnime extends StatelessWidget {
  const PopularAnime({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Popular')),
      body: ValueListenableBuilder<String>(
        valueListenable: SourceManager.activeNotifier,
        builder: (context, activeId, child) {
          final source = SourceManager().active;
          return AnimeGrid(
            key: ValueKey(activeId),
            loadPage: (page) => source.browse(BrowseKind.popular, page: page),
          );
        },
      ),
    );
  }
}
