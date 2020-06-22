import 'package:AnimeGo/core/Global.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Settings class
class Settings extends StatefulWidget {
  final bool showAppBar;
  Settings({Key key, this.showAppBar = true}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}


class _SettingsState extends State<Settings> {
  final global = Global();
  bool hideDUB;
  String input;

  @override
  void initState() {
    super.initState();
    hideDUB = global.hideDUB;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar ? AppBar(
        title: Text('Settings')
      ) : null,
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
          CheckboxListTile(
            title: Text('Hide Dub'),
            subtitle: Text('Hide all dub anime if you prefer sub'),
            onChanged: (bool value) => updateHideDUB(value),
            value: hideDUB,
          ),
          ListTile(
            title: Text('Feedback'),
            subtitle: Text('Send an email to the developer'),
            onTap: () => launch(Global.email),
          ),
          ListTile(
            title: Text('Source code'),
            subtitle: Text(Global.github),
            onTap: () => launch(Global.github),
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

  /// Hides dub
  Future<void> updateHideDUB(bool value) async {
    if (value == hideDUB) return;
    global.hideDUB = value;
    setState(() {
      hideDUB = value;
    });
  }
}
