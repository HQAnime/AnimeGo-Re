import 'package:AnimeGo/core/Global.dart';
import 'package:flutter/material.dart';

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
              children: <Widget>[
                SizedBox(
                  height: 30,
                  child: TextField(
                    controller: TextEditingController(text: global.getDomain()),
                    onChanged: (t) => this.input = t,
                    onEditingComplete: () {
                      if (this.input.endsWith('/')) {
                        // Remove last '?'
                        this.input = this.input.substring(0, this.input.length - 1);
                      }

                      FocusScope.of(context).requestFocus(FocusNode());
                      global.updateDomain(this.input);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "Domain will be updated automatically but you can still update yourself but make sure it is the right link",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
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
