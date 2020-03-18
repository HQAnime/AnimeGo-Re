import 'package:AnimeGo/core/Global.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Settings class
class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}


class _SettingsState extends State<Settings> {
  final global = Global();
  String input;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings')
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Website link'),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(global.getDomain()),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "The link will be updated automatically\nIn certain regions, this website doesn't work\nPlease tap me and check if it works for you",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
            onTap: () => launch(global.getDomain()),
          ),
          ListTile(
            title: Text('Feedback'),
            subtitle: Text('Send an email to the developer'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Source code'),
            subtitle: Text(Global.github),
            onTap: () {},
          ),
          ListTile(
            title: Text('Check for update'),
            subtitle: Text(Global.appVersion),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
