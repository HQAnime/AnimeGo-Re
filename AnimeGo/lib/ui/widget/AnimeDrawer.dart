import 'package:AnimeGo/ui/page/Settings.dart';
import 'package:AnimeGo/ui/widget/GenreList.dart';
import 'package:flutter/material.dart';

/// AnimeDrawer class
class AnimeDrawer extends StatelessWidget {
  AnimeDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'AnimeGo Re',
                style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.deepOrange,
            ),
          ),
          Expanded(
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView(
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
                    onTap: () => this.push(context, Settings())
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Push to new screen and also remove all routes in the middle
  void push(BuildContext context, Widget screen) {
    // Pop the drawer
    Navigator.pop(context);
    // How to push to new screen?
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
