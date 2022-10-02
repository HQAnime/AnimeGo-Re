import 'package:animego/core/Firebase.dart';
import 'package:animego/core/Global.dart';
import 'package:animego/core/NativePlayer.dart';
import 'package:animego/core/Util.dart';
import 'package:animego/core/model/BasicAnime.dart';
import 'package:animego/core/model/MP4Info.dart';
import 'package:animego/core/model/OneEpisodeInfo.dart';
import 'package:animego/core/model/VideoServer.dart';
import 'package:animego/core/parser/MP4Parser.dart';
import 'package:animego/core/parser/OneEpisodeParser.dart';
import 'package:animego/core/webview_player.dart';
import 'package:animego/ui/interface/Embeddable.dart';
import 'package:animego/ui/page/AnimeDetailPage.dart';
import 'package:animego/ui/page/CategoryPage.dart';
import 'package:animego/ui/page/VideoPlayerPage.dart';
import 'package:animego/ui/page/WatchAnimePage.dart';
import 'package:animego/ui/page/tablet/TabletAnimePage.dart';
import 'package:animego/ui/widget/LoadingSwitcher.dart';
import 'package:animego/ui/widget/SearchAnimeButton.dart';
import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// EpisodePage class
class EpisodePage extends StatefulWidget implements Embeddable {
  const EpisodePage({
    Key? key,
    required this.info,
    this.embedded = false,
    this.onEpisodeInfoLoaded,
  }) : super(key: key);

  final BasicAnime? info;
  @override
  final bool embedded;
  final void Function(OneEpisodeInfo?)? onEpisodeInfoLoaded;

  @override
  State<EpisodePage> createState() => _EpisodePageState();
}

class _EpisodePageState extends State<EpisodePage>
    with SingleTickerProviderStateMixin {
  final _logger = Logger('EpisodePage');
  String? link;
  OneEpisodeInfo? info;
  final global = Global();
  String? fomattedName;
  List<MP4Info> mp4List = [];
  String? downloadLink;

  @override
  void initState() {
    super.initState();
    // embeded must have the callback method
    assert(widget.embedded ^ (widget.onEpisodeInfoLoaded != null) == false,
        'embedded must have the onEpisodeInfoLoaded method');
    loadEpisodeInfo(widget.info?.link);

    FirebaseEventService().logUseEpisode();
  }

  loadEpisodeInfo(String? link) {
    setState(() {
      info = null;
      mp4List = [];
    });

    final parser = OneEpisodeParser(global.getDomain() + (link ?? ''));
    parser.downloadHTML().then((body) {
      if (mounted) {
        setState(() {
          info = parser.parseHTML(body);
          if (widget.onEpisodeInfoLoaded != null) {
            widget.onEpisodeInfoLoaded!(info);
          }

          info?.currentEpisodeLink = link;
          fomattedName = info?.name?.split(RegExp(r'[^a-zA-Z0-9]')).join('+');
        });

        getMP4List();
      }
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
        actions: [
          downloadLink != null
              ? IconButton(
                  onPressed: () {
                    launchUrlString(downloadLink!);
                  },
                  icon: const Icon(Icons.download),
                )
              : const SizedBox.shrink(),
        ],
        automaticallyImplyLeading: widget.embedded ? false : true,
      ),
      body: LoadingSwitcher(
        loading: info == null,
        // Only do the animation for the first time, not for the mp4 list
        repeat: mp4List.isEmpty,
        child: renderBody(),
      ),
      bottomNavigationBar: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: info != null ? 1 : 0,
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: info != null
                ? <Widget>[
                    Tooltip(
                      message: 'Previous episode',
                      child: IconButton(
                        onPressed: info?.prevEpisodeLink != null
                            ? () {
                                loadEpisodeInfo(
                                  info?.prevEpisodeLink,
                                );
                              }
                            : null,
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                    SearchAnimeButton(name: fomattedName),
                    Tooltip(
                      message: 'Next episode',
                      child: IconButton(
                        onPressed: info?.nextEpisodeLink != null
                            ? () {
                                loadEpisodeInfo(
                                  info?.nextEpisodeLink,
                                );
                              }
                            : null,
                        icon: const Icon(Icons.arrow_forward),
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
    if (info == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (info?.currentEpisode == null) {
      // Sometimes, it doesn't load properly
      return const Center(
        child: Text('Failed to load. Please try again.'),
      );
    } else {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              widget.embedded
                  ? const SizedBox.shrink()
                  : ListTile(
                      title:
                          const Text('Anime Info', textAlign: TextAlign.center),
                      subtitle: Text(
                        info?.name ?? 'No information',
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          Util.platformPageRoute(
                            // this is only visible on mobile so no need to go to tablet page
                            builder: (context) {
                              if (Util(context).isTablet()) {
                                return TabletAnimePage(info: info);
                              }
                              return AnimeDetailPage(info: info);
                            },
                          ),
                        );
                      },
                    ),
              ListTile(
                title: const Text('Category', textAlign: TextAlign.center),
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
              const Divider(),
              Row(
                // move Watch Directly section up
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Server List',
                          textAlign: TextAlign.center),
                      subtitle: Column(
                        children: renderServerList(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text(
                        'Watch Directly',
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Column(
                        children: renderMP4List(),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(),
              ),
              buildWatchStatus(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 32, right: 32),
                child: Text(
                  'Please note that this app does not have any controls over these sources',
                  textAlign: TextAlign.center,
                ),
              ),
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
    if (info == null) return [];
    return info!.servers.map((e) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
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
                      title: const Text(
                        'Video playback',
                        textAlign: TextAlign.center,
                      ),
                      content: Wrap(
                        alignment: WrapAlignment.spaceAround,
                        spacing: 2,
                        runSpacing: 2,
                        children: [
                          ElevatedButton(
                            onPressed: () => openWithOtherApps(e),
                            child: const Text('Use other apps'),
                          ),
                          ElevatedButton(
                            onPressed: () => openInAppPlayer(e),
                            child: const Text('Use in-app player'),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 16.0),
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
                if (e.link != null) {
                  // launchUrlString(e.link!);
                  final webview = WebViewPlayer(e.link!);
                  webview.play();
                  _addToHistory();
                }
              }
            },
            label: Text(e.title ?? 'Unknown'),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> renderMP4List() {
    if (mp4List.isEmpty) {
      return [
        const Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ];
    }

    return mp4List.map((e) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: ActionChip(
          onPressed: () {
            FirebaseEventService().logWatchDirectly();
            if (Util.isMobile()) {
              Navigator.of(context).push(
                Util.platformPageRoute(builder: (context) {
                  return VideoPlayerPage(
                    videoLink: e.link,
                    refererLink: e.referrer,
                    title: info?.episodeName,
                  );
                }),
              );
            } else {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: const Text('AnimeGo is paused'),
                  content: const Text(
                    'Please close the program after you finish watching.\nMake sure it is closed not minimised or running in the background. \nOn macOS, you can use ⌘Q to quit the app.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        _addToHistory();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              );

              Future.delayed(const Duration(milliseconds: 300), () {
                // Add a short delay to make sure the alert is shown
                NativePlayer(link: e.link, referrer: e.referrer).play();
              });
            }
          },
          label: Text(e.name ?? 'Unknown'),
        ),
      );
    }).toList();
  }

  getMP4List() async {
    for (VideoServer server in info?.servers ?? []) {
      final link = server.link;
      final title = server.title;
      if (link != null && title != null) {
        final titleLower = title.toLowerCase();
        if (titleLower.contains('streaming') || titleLower.contains('vidcdn')) {
          // this is the link we need to parse
          if (mounted) {
            setState(() {
              if (link.contains('embedplus')) {
                downloadLink = link.replaceFirst('embedplus', 'download');
              } else if (link.contains('streaming')) {
                downloadLink = link.replaceFirst('streaming.php', 'download');
              }
            });
            _logger.info('Download link: $downloadLink');
          }

          final parser = MP4Parser(downloadLink ?? '');
          final html = await parser.downloadHTML();
          if (html == null) {
            // This is probably a timeout, try another one if possible
            continue;
          }

          final mp4s = parser.parseHTML(html);
          if (mounted && mp4s != null && mp4s.isNotEmpty) {
            setState(() {
              mp4List = mp4s;
            });
          }

          // there are multiple sources so need to early quit
          break;
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
