import 'package:AnimeGo/core/Global.dart';
import 'package:AnimeGo/core/Util.dart';
import 'package:AnimeGo/core/model/BasicAnime.dart';
import 'package:AnimeGo/core/model/OneEpisodeInfo.dart';
import 'package:AnimeGo/core/model/VideoServer.dart';
import 'package:AnimeGo/core/parser/OneEpisodeParser.dart';
import 'package:AnimeGo/ui/page/AnimeDetailPage.dart';
import 'package:AnimeGo/ui/page/CategoryPage.dart';
import 'package:AnimeGo/ui/page/WatchAnimePage.dart';
import 'package:AnimeGo/ui/widget/LoadingSwitcher.dart';
import 'package:AnimeGo/ui/widget/SearchAnimeButton.dart';
import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// EpisodePage class
class EpisodePage extends StatefulWidget {
  final BasicAnime info;
  EpisodePage({Key key, @required this.info}) : super(key: key);

  @override
  _EpisodePageState createState() => _EpisodePageState();
}

class _EpisodePageState extends State<EpisodePage>
    with SingleTickerProviderStateMixin {
  String link;
  OneEpisodeInfo info;
  final global = Global();
  String fomattedName;

  @override
  void initState() {
    super.initState();
    this.loadEpisodeInfo(widget.info.link);
  }

  loadEpisodeInfo(String link) {
    setState(() {
      info = null;
    });

    final parser = OneEpisodeParser(global.getDomain() + link);
    parser.downloadHTML().then((body) {
      setState(() {
        this.info = parser.parseHTML(body);
        this.fomattedName = info.name.split(RegExp(r"[^a-zA-Z0-9]")).join('+');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        info == null ? 'Loading...' : 'Episode ${info.currentEpisode}',
      )),
      body: LoadingSwitcher(
        loading: this.info == null,
        child: this.renderBody(),
        repeat: true,
      ),
      bottomNavigationBar: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: this.info != null ? 1 : 0,
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: this.info != null
                ? <Widget>[
                    Tooltip(
                      message: 'Previous episode',
                      child: IconButton(
                        onPressed: this.info.prevEpisodeLink != null
                            ? () {
                                this.loadEpisodeInfo(this.info.prevEpisodeLink);
                              }
                            : null,
                        icon: Icon(Icons.arrow_back),
                      ),
                    ),
                    SearchAnimeButton(name: fomattedName),
                    Tooltip(
                      message: 'Next episode',
                      child: IconButton(
                        onPressed: this.info.nextEpisodeLink != null
                            ? () {
                                this.loadEpisodeInfo(this.info.nextEpisodeLink);
                              }
                            : null,
                        icon: Icon(Icons.arrow_forward),
                      ),
                    ),
                  ]
                : [],
          ),
        ),
      ),
    );
  }

  Widget renderBody() {
    if (this.info == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text('Anime Info', textAlign: TextAlign.center),
                subtitle: Text(info.name, textAlign: TextAlign.center),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AnimeDetailPage(info: info)),
                  );
                },
              ),
              ListTile(
                title: Text('Category', textAlign: TextAlign.center),
                subtitle: Text(info.category, textAlign: TextAlign.center),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryPage(
                            url: info.categoryLink, title: info.category)),
                  );
                },
              ),
              ListTile(
                title: Text('Server List', textAlign: TextAlign.center),
                subtitle: Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: renderServerList(),
                  ),
                ),
              ),
              Text(
                'Please note that this app does not\nhave any controls over these sources',
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Divider(),
              ),
              buildWatchStatus(),
            ],
          ),
        ),
      );
    }
  }

  Widget buildWatchStatus() {
    final watched = global.hasWatched(info);
    return Column(
      children: [
        Text(watched ? 'You have watched this episode' : 'Not yet watched'),
        Icon(watched ? Icons.check : Icons.close)
      ],
    );
  }

  List<Widget> renderServerList() {
    return this.info.servers.map((e) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Tooltip(
          message: 'Watch on ${e.title} server',
          child: ActionChip(
            onPressed: () {
              if (Util.isMobile()) {
                if (Util.isAndroid()) {
                  // Show a dialog to ask whether users want to watch in app or not
                  showDialog(
                    context: context,
                    builder: (c) => AlertDialog(
                      title:
                          Text('Video playback', textAlign: TextAlign.center),
                      content: Wrap(
                        alignment: WrapAlignment.spaceAround,
                        spacing: 2,
                        children: [
                          RaisedButton(
                              onPressed: () => openWithOtherApps(e),
                              child: Text('Use other apps')),
                          RaisedButton(
                              onPressed: () => openInAppPlayer(e),
                              child: Text('Use in-app player')),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              'In-app player is simple and blocks all pop-ups while other apps might have more advanced features',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  openInAppPlayer(e);
                }
              } else {
                launch(e.link);
              }
            },
            label: Text(e.title),
          ),
        ),
      );
    }).toList();
  }

  /// Watch with in app player
  openInAppPlayer(VideoServer e) {
    // TODO: why pop here? This makes the iOS unusable
    // Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WatchAnimePage(video: e),
          fullscreenDialog: true),
    );

    _addToHistory();
  }

  /// Watch with in app player
  openWithOtherApps(VideoServer e) {
    Navigator.pop(context);
    AndroidIntent(
      action: 'action_view',
      data: e.link,
    ).launch();

    _addToHistory();
  }

  /// Save this to watch history
  _addToHistory() =>
      Global().addToHistory(BasicAnime(info.episodeName, widget.info.link));
}
