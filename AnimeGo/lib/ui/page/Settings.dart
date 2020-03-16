import 'package:flutter/material.dart';

/// Settings class
class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}


class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings')
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Website link (mostly automatic)'),
            subtitle: SizedBox(
              height: 36,
              child: TextField(

              ),
            ),
          ),
          ListTile(
            title: Text('Feedback'),
            subtitle: Text('Send an email to the developer'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Source code'),
            subtitle: Text('Send an email to the developer'),
            onTap: () {},
          ),
          ListTile(
            title: Text('AnimeGo Re'),
            subtitle: Text('Send an email to the developer'),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
