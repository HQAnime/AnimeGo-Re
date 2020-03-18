import 'package:AnimeGo/ui/page/CategoryPage.dart';
import 'package:AnimeGo/ui/widget/AnimeDrawer.dart';
import 'package:AnimeGo/ui/widget/AnimeGrid.dart';
import 'package:AnimeGo/ui/widget/GenreList.dart';
import 'package:flutter/material.dart';

/// TabletHomePage class
class TabletHomePage extends StatefulWidget {
  TabletHomePage({Key key}) : super(key: key);

  @override
  _TabletHomePageState createState() => _TabletHomePageState();
}


class _TabletHomePageState extends State<TabletHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AnimeGo'),
      ),
      body: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: renderMenu(),
          ),
          Flexible(
            flex: 3,
            child: AnimeGrid(url: '/page-recent-release.html'),
          ),
        ],
      ),
    );
  }

  /// It is similar to `AnimeDrawer` yet different
  Widget renderMenu() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('Seasonal'),
          leading: Icon(Icons.fiber_new),
        ),
        ListTile(
          title: Text('Movie'),
          leading: Icon(Icons.movie),
        ),
        ListTile(
          title: Text('Popular'),
          leading: Icon(Icons.label),
        ),
        ExpansionTile(
          title: Text('Genre'),
          leading: Icon(Icons.list),
          children: <Widget>[
            GenreList()
          ],
        ),
        Divider(),
        ListTile(
          title: Text('History'),
          leading: Icon(Icons.history),
        ),
        ListTile(
          title: Text('Favourite'),
          leading: Icon(Icons.favorite),
        ),
        Divider(),
        ListTile(
          title: Text('Settings'),
          leading: Icon(Icons.settings),
        ),
      ],
    );
  }
}
