import 'package:AnimeGo/ui/page/Favourite.dart';
import 'package:AnimeGo/ui/page/History.dart';
import 'package:AnimeGo/ui/page/SearchAnime.dart';
import 'package:AnimeGo/ui/page/Settings.dart';
import 'package:AnimeGo/ui/widget/AnimeGrid.dart';
import 'package:AnimeGo/ui/widget/GenreList.dart';
import 'package:flutter/material.dart';

/// TabletHomePage class
class TabletHomePage extends StatefulWidget {
  TabletHomePage({Key key}) : super(key: key);

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
        title: Text('AnimeGo'),
      ),
      body: Row(
        children: <Widget>[
          Flexible(
            flex: 3,
            child: renderMenu(),
          ),
          Flexible(
            flex: 7,
            child: renderPage(),
          ),
        ],
      ),
      floatingActionButton: showFab ? FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchAnime())),
      ) : null,
    );
  }

  Widget renderPage() {
    switch (code) {
      case PageCode.latest:
        return AnimeGrid(url: '/page-recent-release.html', key: Key(code.toString()));
        break;
      case PageCode.seasonal:
        return AnimeGrid(url: '/new-season.html', key: Key(code.toString()));
        break;
      case PageCode.movie:
        return AnimeGrid(url: '/anime-movies.html', key: Key(code.toString()));
        break;
      case PageCode.popular:
        return AnimeGrid(url: '/popular.html', key: Key(code.toString()));
        break;
      case PageCode.genre:
        return AnimeGrid(url: this.genre, key: Key(genre));
        break;
      case PageCode.history:
        return History(showAppBar: false);
        break;
      case PageCode.favourite:
        return Favourite(showAppBar: false);
        break;
      case PageCode.setting:
        return Settings(showAppBar: false);
        break;
      default:
        return SizedBox.shrink();
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
        ),
        ListTile(
          title: Text('Seasonal'),
          leading: Icon(Icons.fiber_new),
          onTap: () => setCode(PageCode.seasonal),
        ),
        ListTile(
          title: Text('Movie'),
          leading: Icon(Icons.movie),
          onTap: () => setCode(PageCode.movie),
        ),
        ListTile(
          title: Text('Popular'),
          leading: Icon(Icons.label),
          onTap: () => setCode(PageCode.popular),
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
        ),
        ListTile(
          title: Text('Favourite'),
          leading: Icon(Icons.favorite),
          onTap: () => setCode(PageCode.favourite),
        ),
        Divider(),
        ListTile(
          title: Text('Settings'),
          leading: Icon(Icons.settings),
          onTap: () => setCode(PageCode.setting),
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
