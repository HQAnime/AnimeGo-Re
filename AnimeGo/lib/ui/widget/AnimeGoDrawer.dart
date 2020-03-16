import 'package:AnimeGo/ui/page/GenrePage.dart';
import 'package:AnimeGo/ui/page/Settings.dart';
import 'package:flutter/material.dart';

/// AnimeGoDrawer class
class AnimeGoDrawer extends StatelessWidget {
  AnimeGoDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          // This size box fills the white statur bar
          SizedBox(
            height: 32,
            child: Container(color: Colors.deepOrange),
          ),
          ListView(
            children: <Widget>[
              DrawerHeader(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'AnimeGo Re',
                    style: TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                ),
              ),
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
                leading: Icon(Icons.people),
              ),
              ListTile(
                title: Text('Genre'),
                leading: Icon(Icons.list),
                onTap: () => this.push(context, GenrePage())
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
        ],
      ),
    );
  }

  void push(BuildContext context, Widget screen) {
    // Pop the drawer
    Navigator.pop(context);
    // How to push to new screen?
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}
