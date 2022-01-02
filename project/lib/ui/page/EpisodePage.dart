import 'package:animego/core/Firebase.dart';
import 'package:animego/core/Global.dart';
import 'package:animego/core/NativePlayer.dart';
import 'package:animego/core/Util.dart';
import 'package:animego/core/model/BasicAnime.dart';
import 'package:animego/core/model/OneEpisodeInfo.dart';
import 'package:animego/core/model/VideoServer.dart';
import 'package:animego/core/parser/MP4Parser.dart';
import 'package:animego/core/parser/OneEpisodeParser.dart';
import 'package:animego/ui/interface/Embeddable.dart';
import 'package:animego/ui/page/AnimeDetailPage.dart';
import 'package:animego/ui/page/CategoryPage.dart';
import 'package:animego/ui/page/VideoPlayerPage.dart';
import 'package:animego/ui/page/WatchAnimePage.dart';
import 'package:animego/ui/widget/LoadingSwitcher.dart';
import 'package:animego/ui/widget/SearchAnimeButton.dart';
import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// EpisodePage class
class EpisodePage extends StatefulWidget implements Embeddable {
  const EpisodePage({
    Key? key,
    required this.info,
    this.embedded = false,
  }) : super(key: key);

  final BasicAnime? info;
  final bool embedded;

  @override
  _EpisodePageState createState() => _EpisodePageState();
}

class _EpisodePageState extends State<EpisodePage>
    with SingleTickerProviderStateMixin {
  String? link;
  OneEpisodeInfo? info;
  final global = Global();
  String? fomattedName;

  @override
  void initState() {
    super.initState();
    this.loadEpisodeInfo(widget.info?.link);

    FirebaseEventService().logUseEpisode();
  }

  loadEpisodeInfo(String? link) {
    setState(() {
      info = null;
    });

    final parser = OneEpisodeParser(global.getDomain() + (link ?? ''));
    parser.downloadHTML().then((body) {
      setState(() {
        this.info = parser.parseHTML(body);
        this.info?.currentEpisodeLink = link;
        this.fomattedName =
            info?.name?.split(RegExp(r"[^a-zA-Z0-9]")).join('+');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          info == null
              ? 'Loading...'
              : 'Episode ${info?.currentEpisode ?? '??'}',
        ),
        automaticallyImplyLeading: widget.embedded ? false : true,
      ),
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
                        onPressed: this.info?.prevEpisodeLink != null
                            ? () {
                                this.loadEpisodeInfo(
                                  this.info?.prevEpisodeLink,
                                );
                              }
                            : null,
                        icon: Icon(Icons.arrow_back),
                      ),
                    ),
                    SearchAnimeButton(name: fomattedName),
                    Tooltip(
                      message: 'Next episode',
                      child: IconButton(
                        onPressed: this.info?.nextEpisodeLink != null
                            ? () {
                                this.loadEpisodeInfo(
                                  this.info?.nextEpisodeLink,
                                );
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
    } else if (this.info?.currentEpisode == null) {
      // Sometimes, it doesn't load properly
      return Center(
        child: Text('Failed to load. Please try again.'),
      );
    } else {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              widget.embedded
                  ? SizedBox.shrink()
                  : ListTile(
                      title: Text('Anime Info', textAlign: TextAlign.center),
                      subtitle: Text(
                        info?.name ?? 'No information',
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          Util.platformPageRoute(
                            builder: (context) => AnimeDetailPage(info: info),
                          ),
                        );
                      },
                    ),
              ListTile(
                title: Text('Category', textAlign: TextAlign.center),
                subtitle: Text(
                  info?.category ?? 'Unknown',
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    Util.platformPageRoute(
                      builder: (context) => CategoryPage(
                        url: info?.categoryLink,
                        title: info?.category,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Server List', textAlign: TextAlign.center),
                subtitle: Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: renderServerList() ?? [],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => parseM3U8Link(),
                child: Text('Text video parsing'),
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

  List<Widget>? renderServerList() {
    return this.info?.servers.map((e) {
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
                      title: Text(
                        'Video playback',
                        textAlign: TextAlign.center,
                      ),
                      content: Wrap(
                        alignment: WrapAlignment.spaceAround,
                        spacing: 2,
                        children: [
                          ElevatedButton(
                            onPressed: () => openWithOtherApps(e),
                            child: Text('Use other apps'),
                          ),
                          ElevatedButton(
                            onPressed: () => openInAppPlayer(e),
                            child: Text('Use in-app player'),
                          ),
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
                if (e.link != null) launch(e.link!);
              }
            },
            label: Text(e.title ?? 'Unknown'),
          ),
        ),
      );
    }).toList();
  }

  parseM3U8Link() async {
    for (VideoServer server in this.info?.servers ?? []) {
      final link = server.link;
      final title = server.title;
      if (link != null && title != null) {
        if (title.toLowerCase().contains('vidcdn')) {
          // this is the link we need to parse
          final parser = MP4Parser(link.replaceFirst('embedplus', 'download'));
          final html = await parser.downloadHTML();
          final mp4s = parser.parseHTML(html);

          if (mp4s != null && mp4s.length > 0) {
            if (Util.isMobile()) {
              Navigator.of(context).push(
                Util.platformPageRoute(
                  builder: (context) => VideoPlayerPage(
                    videoLink: mp4s.last.link,
                  ),
                ),
              );
            } else {
              NativePlayer(link: mp4s.last.link!, referrer: '')
                  .play(NativePlayerType.VLC);
              // Navigator.of(context).push(
              //   Util.platformPageRoute(
              //     builder: (context) => VLCPlayerPage(
              //       refererLink: '',
              //       videoLink: mp4s.last.link!,
              //     ),
              //   ),
              // );
            }
          }
        }
      }
    }
  }

  /// Watch with in app player
  openInAppPlayer(VideoServer e) {
    // Only android has the
    if (Util.isAndroid()) {
      Navigator.pop(context);
    }

    Navigator.push(
      context,
      Util.platformPageRoute(
        builder: (context) => WatchAnimePage(video: e),
        fullscreenDialog: true,
      ),
    );

    FirebaseEventService().logWatchInApp();

    _addToHistory();
  }

  /// Watch with in app player
  openWithOtherApps(VideoServer e) {
    Navigator.pop(context);
    AndroidIntent(
      action: 'action_view',
      data: e.link,
    ).launch();

    FirebaseEventService().logWatchWithOthers();

    _addToHistory();
  }

  /// Save this to watch history
  _addToHistory() => Global().addToHistory(
        BasicAnime(
          info?.episodeName,
          info?.currentEpisodeLink,
        ),
      );
}
