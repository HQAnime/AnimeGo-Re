import 'dart:math';

import 'package:animego/core/Firebase.dart';
import 'package:animego/core/Global.dart';
import 'package:animego/core/Util.dart';
import 'package:animego/core/model/AnimeDetailedInfo.dart';
import 'package:animego/core/model/BasicAnime.dart';
import 'package:animego/core/model/EpisodeSection.dart';
import 'package:animego/core/model/EpisodelInfo.dart';
import 'package:animego/core/parser/DetailedInfoParser.dart';
import 'package:animego/core/parser/EpisodeListParser.dart';
import 'package:animego/ui/interface/Embeddable.dart';
import 'package:animego/ui/page/CategoryPage.dart';
import 'package:animego/ui/page/EpisodePage.dart';
import 'package:animego/ui/page/GenrePage.dart';
import 'package:animego/ui/widget/LoadingSwitcher.dart';
import 'package:animego/ui/widget/SearchAnimeButton.dart';
import 'package:flutter/material.dart';

/// AnimeDetailPage class
class AnimeDetailPage extends StatefulWidget implements Embeddable {
  const AnimeDetailPage({
    Key? key,
    required this.info,
    this.embedded = false,
    this.onEpisodeSelected,
  }) : super(key: key);

  final BasicAnime? info;
  @override
  final bool embedded;
  final void Function(EpisodeInfo?)? onEpisodeSelected;

  @override
  State<AnimeDetailPage> createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {
  bool loading = true;
  bool loadingEpisode = false;
  bool error = false;
  String? currEpisode;
  AnimeDetailedInfo? info;
  List<EpisodeInfo> episodes = [];
  final global = Global();

  bool isFavourite = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // embeded must have the callback method
    assert(widget.embedded ^ (widget.onEpisodeSelected != null) == false,
        'embedded must have the onEpisodeSelected method');

    FirebaseEventService().logUseAnimeInfo();

    // Load data here
    final parser =
        DetailedInfoParser(global.getDomain() + (widget.info?.link ?? ''));
    parser.downloadHTML().then((body) {
      setState(() {
        loading = false;
        info = parser.parseHTML(body);
        error = info?.status == null;
        isFavourite = global.isFavourite(widget.info);

        // Auto load if there is only one section
        if (info?.episodes.length == 1) {
          loadEpisode(info?.episodes.first);
        } else {
          // load the last episode
          loadEpisode(info?.episodes.last);
        }
      });

      // scroll the view to the bottom to show episode list
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (error) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Unknown Error'),
        ),
        body: const Center(
          child: Text('Something went very wrong'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loading ? 'Loading...' : info?.status ?? 'Error'),
        actions: <Widget>[
          if (!loading && info != null)
            IconButton(
              icon: Icon(
                isFavourite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () {
                FirebaseEventService().logUseFavourite();
                if (isFavourite) {
                  global.removeFromFavourite(widget.info);
                } else {
                  global.addToFavourite(widget.info);
                }

                setState(() {
                  isFavourite = !isFavourite;
                });
              },
            ),
        ],
      ),
      body: SafeArea(
        child: LoadingSwitcher(
          loading: loading,
          child: renderBody(),
        ),
      ),
    );
  }

  Widget renderBody() {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView(
        controller: _scrollController,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              info?.name ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: info?.image != null
                      ? Image.network(info!.image!)
                      : Container(),
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      centeredListTile('Released', info?.released ?? 'Unkown'),
                      centeredListTile(
                          'Episode(s)', info?.lastEpisode ?? 'Unkown'),
                      ListTile(
                        title:
                            const Text('Category', textAlign: TextAlign.center),
                        subtitle: ActionChip(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              Util.platformPageRoute(builder: (context) {
                                return CategoryPage(
                                  // The domain will be added later so DON'T ADD IT HERE
                                  url: info?.categoryLink,
                                  title: info?.category,
                                );
                              }),
                            );
                          },
                          label: Text(
                            info?.category ?? 'Unknown',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: info?.image != null
                        ? Image.network(info!.image!)
                        : Container(),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          SearchAnimeButton(name: widget.info?.name),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: ListTile(
              title: const Text('Genre', textAlign: TextAlign.center),
              subtitle: Wrap(
                alignment: WrapAlignment.center,
                spacing: 4,
                runSpacing: 4,
                children: info?.genre.map((e) {
                      return ActionChip(
                        label: Text(e.getAnimeGenreName()),
                        onPressed: () {
                          Navigator.push(
                            context,
                            Util.platformPageRoute(builder: (context) {
                              return GenrePage(genre: e);
                            }),
                          );
                        },
                      );
                    }).toList(growable: false) ??
                    [],
              ),
            ),
          ),
          centeredListTile('Summary', info?.summary ?? 'No summary'),
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Episode List',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: renderEpisodes(),
          ),
          renderEpisodeList(context),
        ],
      );
    }
  }

  List<Widget> renderEpisodes() {
    if (info == null) return [];
    // This is for new animes where they haven't aired yet
    if (info!.episodes.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('No episodes'),
        )
      ];
    }

    return info!.episodes.map((e) {
      return Padding(
        padding: const EdgeInsets.all(2),
        child: InkWell(
          onTap: loadingEpisode
              ? null
              : () {
                  loadEpisode(e);
                },
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              '${e.episodeStart} - ${e.episodeEnd}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: currEpisode == e.episodeStart
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
            ),
          ),
        ),
      );
    }).toList(growable: false);
  }

  void loadEpisode(EpisodeSection? e) {
    // Don't update if the selection is the same
    if (e?.episodeStart == currEpisode) return;

    setState(() {
      currEpisode = e?.episodeStart;
      loadingEpisode = true;
    });

    FirebaseEventService().logUseEpisodeList();

    final parser = EpisodeListParser(
      '${global.getDomain()}/load-list-episode',
      e,
    );

    parser.downloadHTML().then((body) {
      setState(() {
        episodes = parser.parseHTML(body);
        loadingEpisode = false;
      });
    });
  }

  Widget renderEpisodeList(BuildContext context) {
    if (currEpisode == null) {
      return Container();
    } else if (loadingEpisode) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 4,
          runSpacing: 4,
          children: episodes.map((e) {
            return Padding(
              padding: const EdgeInsets.all(4),
              child: ElevatedButton(
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  if (widget.embedded) {
                    // Pass this episode to the parent
                    if (widget.onEpisodeSelected != null) {
                      widget.onEpisodeSelected!(e);
                    }
                  } else {
                    Navigator.push(
                      context,
                      Util.platformPageRoute(builder: (context) {
                        return EpisodePage(info: e);
                      }),
                    );
                  }
                },
                child: Text(e.name ?? '??'),
              ),
            );
          }).toList(growable: false),
        ),
      );
    }
  }

  Widget centeredListTile(String title, String subtitle) {
    return ListTile(
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      subtitle: Text(
        subtitle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
