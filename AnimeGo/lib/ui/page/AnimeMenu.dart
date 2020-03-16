import 'package:flutter/material.dart';

import '../widget/GenreList.dart';

/// AnimeMenu class, it has everything in it (genre, movie, history, favourite and settings)
class AnimeMenu extends StatefulWidget {
  AnimeMenu({Key key}) : super(key: key);

  @override
  _AnimeMenuState createState() => _AnimeMenuState();
}

class _AnimeMenuState extends State<AnimeMenu> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AnimeGo')
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Genre'),
            subtitle: Text('Browse anime by genre'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Movie'),
            subtitle: Text('All the latest anime movies'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Popular'),
            subtitle: Text('Check out what\'s popular right now'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            title: Text('History'),
            subtitle: Text('Browse your watch history'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Favourite'),
            subtitle: Text('Browse your saved anime list'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            title: Text('Settings'),
            subtitle: Text('Website domain, Feedback, Source code'),
            onTap: () {},
          ),
          SizedBox(
            height: 64,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {},
      ),
    );
  }
}
