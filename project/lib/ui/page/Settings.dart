import 'package:animego/core/Firebase.dart';
import 'package:animego/core/Global.dart';
import 'package:animego/core/Util.dart';
import 'package:animego/ui/interface/Embeddable.dart';
import 'package:animego/ui/widget/AnimeFlatButton.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Settings class
class Settings extends StatefulWidget implements Embeddable {
  const Settings({
    Key? key,
    this.embedded = false,
  }) : super(key: key);

  @override
  final bool embedded;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final global = Global();
  bool? hideDUB;
  late String input;
  TextEditingController? controller;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    hideDUB = global.hideDUB;
    final currentDomain = global.getDomain();
    controller =
        TextEditingController.fromValue(TextEditingValue(text: currentDomain));
    input = currentDomain;

    FirebaseEventService().logUseSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.embedded ? null : AppBar(title: const Text('Settings')),
      body: ListView(
        controller: scrollController,
        children: <Widget>[
          ListTile(
            isThreeLine: true,
            title: const Text('Support me :)'),
            subtitle: const Text(
                'If you really like this app, you can consider buying me a pizza but any amount is greatly appreciated'),
            onTap: () => launchUrlString('https://www.paypal.me/yihengquan'),
          ),
          ListTile(
            title: const Padding(
              padding: EdgeInsets.only(top: 16),
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
                  onChanged: (value) => input = value,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    global.updateDomain(input);
                    Future.delayed(const Duration(milliseconds: 400)).then(
                      (_) => showDialog(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: const Text('Domain has been updated'),
                          content: Text(
                            "The domain is now $input.\n\nIf it doesn't load, please change it back to the default domain. Note that the app will always get the latest domain based on the saved domain automatically and it might override your custom domain.",
                          ),
                          actions: [
                            AnimeFlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Close'),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "The link will be updated automatically.\nIn certain regions, this website doesn't work.\nTry using a VPN and restart the app.\nPlease tap me and check if it works for you.\n\nDon't change it if you don't know what you are doing.\nThe default domain is ${Global.defaultDomain}.\nPlease try updating to the default if current one is not working.",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
            onTap: () => launchUrlString(global.getDomain()),
          ),
          CheckboxListTile(
            title: const Text('Hide Dub'),
            subtitle: const Text('Hide all dub anime if you prefer sub'),
            onChanged: (bool? value) => updateHideDUB(value),
            value: hideDUB,
          ),
          const Divider(),
          ListTile(
            title: const Text('Feedback'),
            subtitle: const Text('Send an email to the developer'),
            onTap: () => launchUrlString(Global.email),
          ),
          ListTile(
            onTap: () {
              Share.share(Global.latestRelease);
            },
            title: const Text('Share AnimeGo'),
            subtitle: const Text('Share to your friends if you like AnimeGo'),
          ),
          const Divider(),
          ListTile(
            title: const Text('Source code'),
            subtitle: const Text(Global.github),
            onTap: () => launchUrlString(Global.github),
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            subtitle:
                const Text('AnimeGo collects limited data to improve the app'),
            onTap: () => launchUrlString(Global.privacyPolicy),
          ),
          ListTile(
            title: const Text('Licenses'),
            subtitle: const Text('Check all open source licenses'),
            onTap: () {
              Navigator.push(
                context,
                Util.platformPageRoute(
                  builder: (BuildContext context) => const LicensePage(
                    applicationName: 'AnimeGo',
                    applicationVersion: Global.appVersion,
                    applicationLegalese: 'An unofficial app for gogoanime',
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Check for update'),
            subtitle: const Text(Global.appVersion),
            onTap: () => global.checkForUpdate(context, force: true),
          ),
          ...renderExtra(),
        ],
      ),
    );
  }

  /// Render different UI based on Desktop or Mobile
  List<Widget> renderExtra() {
    if (Util.isDesktop()) {
      return [
        const Divider(),
        ListTile(
          title: const Text('VLC media player'),
          onTap: () => launchUrlString('https://www.videolan.org/vlc/'),
        ),
        ListTile(
          title: const Text('MPV player'),
          onTap: () => launchUrlString('https://mpv.io/'),
        ),
      ];
    } else {
      return [];
    }
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
