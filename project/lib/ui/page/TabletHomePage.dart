import 'package:animego/core/source/AnimeSource.dart';
import 'package:animego/core/source/SourceManager.dart';
import 'package:animego/ui/page/Favourite.dart';
import 'package:animego/ui/page/History.dart';
import 'package:animego/ui/page/SearchAnime.dart';
import 'package:animego/ui/page/Settings.dart';
import 'package:animego/ui/page/WebSourcePage.dart';
import 'package:animego/ui/widget/AnimeGrid.dart';
import 'package:animego/ui/widget/GenreList.dart';
import 'package:flutter/material.dart';

/// TabletHomePage class
class TabletHomePage extends StatefulWidget {
  const TabletHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _TabletHomePageState createState() => _TabletHomePageState();
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
        title: Text('AnimeGo Re'),
      ),
      body: Row(
        children: <Widget>[
          Flexible(
            flex: 3,
            child: renderMenu(),
          ),
          Flexible(
            flex: 7,
            child: ValueListenableBuilder<String>(
              valueListenable: SourceManager.activeNotifier,
              builder: (context, activeId, child) => renderPage(activeId),
            ),
          ),
        ],
      ),
      floatingActionButton: ValueListenableBuilder<String>(
        valueListenable: SourceManager.activeNotifier,
        builder: (context, activeId, child) {
          if (!showFab || SourceManager().active.isWebView) {
            return const SizedBox.shrink();
          }
          return FloatingActionButton(
            child: Icon(Icons.search),
            tooltip: 'Search anime',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchAnime(),
                fullscreenDialog: true,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget renderPage(String activeId) {
    final source = SourceManager().active;

    // Web-only sources replace every browsable feed with the embedded site.
    if (source.isWebView &&
        code != PageCode.history &&
        code != PageCode.favourite &&
        code != PageCode.setting) {
      return WebSourcePage(key: ValueKey(activeId), source: source);
    }

    switch (code) {
      case PageCode.latest:
        return AnimeGrid(
          key: ValueKey('$activeId:latest'),
          loadPage: (page) => source.browse(BrowseKind.latest, page: page),
        );
      case PageCode.seasonal:
        return AnimeGrid(
          key: ValueKey('$activeId:seasonal'),
          loadPage: (page) => source.browse(BrowseKind.seasonal, page: page),
        );
      case PageCode.movie:
        return AnimeGrid(
          key: ValueKey('$activeId:movie'),
          loadPage: (page) => source.browse(BrowseKind.movie, page: page),
        );
      case PageCode.popular:
        return AnimeGrid(
          key: ValueKey('$activeId:popular'),
          loadPage: (page) => source.browse(BrowseKind.popular, page: page),
        );
      case PageCode.genre:
        return AnimeGrid(
          key: ValueKey('$activeId:$genre'),
          loadPage: (page) => source.category(this.genre, page: page),
        );
      case PageCode.history:
        return History(showAppBar: false);
      case PageCode.favourite:
        return Favourite(showAppBar: false);
      case PageCode.setting:
        return Settings(showAppBar: false);
    }
  }

  /// It is similar to `AnimeDrawer` yet different
  Widget renderMenu() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('Latest'),
          leading: Icon(Icons.new_releases),
          onTap: () => setCode(PageCode.latest),
          selected: code == PageCode.latest,
        ),
        ListTile(
          title: Text('Seasonal'),
          leading: Icon(Icons.fiber_new),
          onTap: () => setCode(PageCode.seasonal),
          selected: code == PageCode.seasonal,
        ),
        ListTile(
          title: Text('Movie'),
          leading: Icon(Icons.movie),
          onTap: () => setCode(PageCode.movie),
          selected: code == PageCode.movie,
        ),
        ListTile(
          title: Text('Popular'),
          leading: Icon(Icons.label),
          onTap: () => setCode(PageCode.popular),
          selected: code == PageCode.popular,
        ),
        ExpansionTile(
          title: Text('Genre'),
          leading: Icon(Icons.list),
          children: <Widget>[
            GenreList(func: (g) {
              this.genre = g;
              setCode(PageCode.genre);
            })
          ],
        ),
        Divider(),
        ListTile(
          title: Text('History'),
          leading: Icon(Icons.history),
          onTap: () => setCode(PageCode.history),
          selected: code == PageCode.history,
        ),
        ListTile(
          title: Text('Favourite'),
          leading: Icon(Icons.favorite),
          onTap: () => setCode(PageCode.favourite),
          selected: code == PageCode.favourite,
        ),
        Divider(),
        ListTile(
          title: Text('Settings'),
          leading: Icon(Icons.settings),
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
          this.showFab = false;
        });
        break;
      default:
        setState(() {
          this.showFab = true;
        });
        break;
    }
  }
}
