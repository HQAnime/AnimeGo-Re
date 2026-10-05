import 'package:animego/core/source/SourceManager.dart';
import 'package:animego/ui/widget/AnimeGrid.dart';
import 'package:flutter/material.dart';

/// SearchAnime class
class SearchAnime extends StatefulWidget {
  const SearchAnime({
    Key? key,
  }) : super(key: key);

  @override
  _SearchAnimeState createState() => _SearchAnimeState();
}

class _SearchAnimeState extends State<SearchAnime> {
  String search = '';
  String formattedSearch = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: TextStyle(fontSize: 20),
          decoration: InputDecoration.collapsed(
            hintText: 'Search anime',
            hintStyle: TextStyle(
              fontSize: 20,
              color: Theme.of(context).hintColor,
            ),
          ),
          autocorrect: false,
          autofocus: true,
          onChanged: (t) {
            setState(() {
              this.search = t;
              this.formattedSearch = '';
            });
          },
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(FocusNode());
            setState(() {
              // Replcae space with %20
              formattedSearch = search.split(' ').join('%20');
            });
          },
        ),
      ),
      body: renderGrid(),
    );
  }

  Widget renderGrid() {
    if (formattedSearch.length < 3) {
      return Container();
    } else {
      return ValueListenableBuilder<String>(
        valueListenable: SourceManager.activeNotifier,
        builder: (context, activeId, child) {
          final source = SourceManager().active;
          return AnimeGrid(
            key: ValueKey(activeId),
            loadPage: (page) => source.search(this.search, page: page),
          );
        },
      );
    }
  }
}
