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
import 'package:animego/ui/widget/AnimeFlatButton.dart';
import 'package:animego/ui/widget/LoadingSwitcher.dart';
import 'package:animego/ui/widget/SearchAnimeButton.dart';
import 'package:flutter/material.dart';

/// AnimeDetailPage class
class AnimeDetailPage extends StatefulWidget implements Embeddable {
  const AnimeDetailPage({
    Key? key,
    required this.info,
    this.embedded = false,
  }) : super(key: key);

  final BasicAnime? info;
  final bool embedded;

  @override
  _AnimeDetailPageState createState() => _AnimeDetailPageState();
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

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    FirebaseEventService().logUseAnimeInfo();

    // Load data here
    final parser =
        DetailedInfoParser(global.getDomain() + (widget.info?.link ?? ''));
    parser.downloadHTML().then((body) {
      setState(() {
        this.loading = false;
        this.info = parser.parseHTML(body);
        this.error = info?.status == null;
        this.isFavourite = global.isFavourite(widget.info);

        // Auto load if there is only one section
        if (info?.episodes.length == 1) {
          this.loadEpisode(info?.episodes.first);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (error) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Unknown Error'),
        ),
        body: Center(
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
                if (isFavourite)
                  global.removeFromFavourite(widget.info);
                else
                  global.addToFavourite(widget.info);

                setState(() {
                  isFavourite = !isFavourite;
                });
              },
            ),
        ],
      ),
      body: SafeArea(
          child: LoadingSwitcher(
        child: this.renderBody(),
        loading: this.loading,
      )),
    );
  }

  Widget renderBody() {
    if (loading) {
      return Center(
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
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
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
                        title: Text('Category', textAlign: TextAlign.center),
                        // TODO: This button is very hidden so the user may not know about this
                        subtitle: AnimeFlatButton(
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
                          child: Text(
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
          Divider(),
          SearchAnimeButton(name: widget.info?.name),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: ListTile(
              title: Text('Genre', textAlign: TextAlign.center),
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
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Episode List',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: info?.episodes.map((e) {
                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: InkWell(
                      onTap: this.loadingEpisode
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
                }).toList(growable: false) ??
                [],
          ),
          renderEpisodeList(context),
        ],
      );
    }
  }

  void loadEpisode(EpisodeSection? e) {
    // Don't update if the selection is the same
    if (e?.episodeStart == this.currEpisode) return;

    setState(() {
      this.currEpisode = e?.episodeStart;
      this.loadingEpisode = true;
    });

    FirebaseEventService().logUseEpisodeList();

    final parser = EpisodeListParser(
      global.getDomain() + '/load-list-episode',
      e,
    );

    parser.downloadHTML().then((body) {
      setState(() {
        this.episodes = parser.parseHTML(body);
        this.loadingEpisode = false;
      });
    });
  }

  Widget renderEpisodeList(BuildContext context) {
    if (currEpisode == null) {
      return Container();
    } else if (loadingEpisode) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 4,
          runSpacing: 4,
          children: this.episodes.map((e) {
            return Padding(
              padding: const EdgeInsets.all(4),
              child: ElevatedButton(
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                    TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  if (widget.embedded) {
                    // Pass this episode to the parent
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
