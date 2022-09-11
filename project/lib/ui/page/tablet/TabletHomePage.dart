import 'package:animego/core/Util.dart';
import 'package:animego/ui/page/Favourite.dart';
import 'package:animego/ui/page/History.dart';
import 'package:animego/ui/page/SearchAnime.dart';
import 'package:animego/ui/page/SeasonalAnime.dart';
import 'package:animego/ui/page/Settings.dart';
import 'package:animego/ui/widget/AnimeGrid.dart';
import 'package:animego/ui/widget/GenreList.dart';
import 'package:flutter/material.dart';

/// TabletHomePage class
class TabletHomePage extends StatefulWidget {
  const TabletHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<TabletHomePage> createState() => _TabletHomePageState();
}

enum PageCode {
  latest,
  seasonal,
  movie,
  popular,
  genre,
  history,
  favourite,
  setting,
}

class _TabletHomePageState extends State<TabletHomePage> {
  // By default, new release
  PageCode code = PageCode.latest;
  String genre = 'nothing';
  bool showFab = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimeGo'),
      ),
      body: Row(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: renderMenu(),
          ),
          Flexible(
            flex: 8,
            child: renderPage(),
          ),
        ],
      ),
      floatingActionButton: showFab
          ? FloatingActionButton(
              tooltip: 'Search anime',
              onPressed: () => Navigator.push(
                context,
                Util.platformPageRoute(
                  builder: (context) => const SearchAnime(),
                  fullscreenDialog: true,
                ),
              ),
              child: const Icon(Icons.search),
            )
          : null,
    );
  }

  Widget renderPage() {
    /// TODO: maybe AnimeGrid shouldn't be used here???
    switch (code) {
      case PageCode.latest:
        return AnimeGrid(
          url: '/page-recent-release.html',
          key: Key(code.toString()),
        );
      case PageCode.seasonal:
        return SeasonalAnime(embedded: true, key: Key(code.toString()));
      case PageCode.movie:
        return AnimeGrid(url: '/anime-movies.html', key: Key(code.toString()));
      case PageCode.popular:
        return AnimeGrid(url: '/popular.html', key: Key(code.toString()));
      case PageCode.genre:
        return AnimeGrid(url: genre, key: Key(genre));
      case PageCode.history:
        return const History(embedded: true);
      case PageCode.favourite:
        return const Favourite(embedded: true);
      case PageCode.setting:
        return const Settings(embedded: true);
      default:
        assert(false, 'Unknown page code');
        return Container();
    }
  }

  /// It is similar to `AnimeDrawer` yet different
  Widget renderMenu() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: const Text('Latest'),
          leading: const Icon(Icons.new_releases),
          onTap: () => setCode(PageCode.latest),
          selected: code == PageCode.latest,
        ),
        ListTile(
          title: const Text('Seasonal'),
          leading: const Icon(Icons.fiber_new),
          onTap: () => setCode(PageCode.seasonal),
          selected: code == PageCode.seasonal,
        ),
        ListTile(
          title: const Text('Movie'),
          leading: const Icon(Icons.movie),
          onTap: () => setCode(PageCode.movie),
          selected: code == PageCode.movie,
        ),
        ListTile(
          title: const Text('Popular'),
          leading: const Icon(Icons.label),
          onTap: () => setCode(PageCode.popular),
          selected: code == PageCode.popular,
        ),
        ExpansionTile(
          title: const Text('Genre'),
          leading: const Icon(Icons.list),
          children: <Widget>[
            GenreList(func: (g) {
              genre = g;
              setCode(PageCode.genre);
            })
          ],
        ),
        const Divider(),
        ListTile(
          title: const Text('History'),
          leading: const Icon(Icons.history),
          onTap: () => setCode(PageCode.history),
          selected: code == PageCode.history,
        ),
        ListTile(
          title: const Text('Favourite'),
          leading: const Icon(Icons.favorite),
          onTap: () => setCode(PageCode.favourite),
          selected: code == PageCode.favourite,
        ),
        const Divider(),
        ListTile(
          title: const Text('Settings'),
          leading: const Icon(Icons.settings),
          onTap: () => setCode(PageCode.setting),
          selected: code == PageCode.setting,
        ),
      ],
    );
  }

  /// Update state to change pages
  void setCode(PageCode code) {
    setState(() {
      this.code = code;
    });

    switch (code) {
      case PageCode.history:
      case PageCode.favourite:
      case PageCode.setting:
        setState(() {
          showFab = false;
        });
        break;
      default:
        setState(() {
          showFab = true;
        });
        break;
    }
  }
}
