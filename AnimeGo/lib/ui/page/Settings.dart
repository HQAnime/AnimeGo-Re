import 'package:animego/core/Global.dart';
import 'package:animego/ui/widget/AnimeFlatButton.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Settings class
class Settings extends StatefulWidget {
  const Settings({
    Key? key,
    this.showAppBar = true,
  }) : super(key: key);

  final bool showAppBar;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final global = Global();
  bool? hideDUB;
  late String input;
  TextEditingController? controller;

  @override
  void initState() {
    super.initState();
    hideDUB = global.hideDUB;
    final currentDomain = global.getDomain();
    controller =
        TextEditingController.fromValue(TextEditingValue(text: currentDomain));
    input = currentDomain;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar ? AppBar(title: Text('Settings')) : null,
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
                TextField(
                  maxLines: 1,
                  autocorrect: false,
                  controller: controller,
                  autofocus: false,
                  onChanged: (value) => this.input = value,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    global.updateDomain(this.input);
                    Future.delayed(Duration(milliseconds: 400)).then(
                      (_) => showDialog(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: Text('Domain has been updated'),
                          content: Text(
                            "The domain is now $input.\n\nIf it doesn't load, please change it back to the default domain. Note that the app will always get the latest domain based on the saved domain automatically and it might override your custom domain.",
                          ),
                          actions: [
                            AnimeFlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Close'),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "The link will be updated automatically\nIn certain regions, this website doesn't work\nPlease tap me and check if it works for you\n\nDon't change it if you don't know what you are doing\nThe default domain is ${Global.defaultDomain}",
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
            onChanged: (bool? value) => updateHideDUB(value),
            value: hideDUB,
          ),
          Divider(),
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
            onTap: () => global.checkForUpdate(context, force: true),
          ),
          Divider(),
          ListTile(
            isThreeLine: true,
            title: Text('Support me :)'),
            subtitle: Text(
                'If you really like this app, you can consider buying me a pizza but any amount is greatly appreciated'),
            onTap: () => launch('https://www.paypal.me/yihengquan'),
          ),
        ],
      ),
    );
  }

  /// Hides dub
  Future<void> updateHideDUB(bool? value) async {
    if (value == hideDUB) return;
    global.hideDUB = value;
    setState(() {
      hideDUB = value;
    });
  }
}
