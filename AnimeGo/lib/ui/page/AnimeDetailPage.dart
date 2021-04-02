import 'dart:math';

import 'package:animego/core/Global.dart';
import 'package:animego/core/model/AnimeDetailedInfo.dart';
import 'package:animego/core/model/BasicAnime.dart';
import 'package:animego/core/model/EpisodeSection.dart';
import 'package:animego/core/model/EpisodelInfo.dart';
import 'package:animego/core/parser/DetailedInfoParser.dart';
import 'package:animego/core/parser/EpisodeListParser.dart';
import 'package:animego/ui/page/CategoryPage.dart';
import 'package:animego/ui/page/EpisodePage.dart';
import 'package:animego/ui/page/GenrePage.dart';
import 'package:animego/ui/widget/LoadingSwitcher.dart';
import 'package:animego/ui/widget/SearchAnimeButton.dart';
import 'package:flutter/material.dart';

/// AnimeDetailPage class
class AnimeDetailPage extends StatefulWidget {
  const AnimeDetailPage({
    Key? key,
    required this.info,
  }) : super(key: key);

  final BasicAnime? info;

  @override
  _AnimeDetailPageState createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {
  bool loading = true;
  bool loadingEpisode = false;
  String? currEpisode;
  late AnimeDetailedInfo info;
  late List<EpisodeInfo> episodes;
  final global = Global();

  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    // Load data here
    final parser = DetailedInfoParser(global.getDomain() + widget.info!.link!);
    parser.downloadHTML().then((body) {
      setState(() {
        this.loading = false;
        this.info = parser.parseHTML(body!);
        this.isFavourite = global.isFavourite(widget.info);

        // Auto load if there is only one section
        if (info.episodes.length == 1) {
          this.loadEpisode(info.episodes.first);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(loading ? 'Loading...' : info.status!),
        actions: <Widget>[
          if (!loading)
            IconButton(
                icon: Icon(
                  isFavourite ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () {
                  if (isFavourite)
                    global.removeFromFavourite(widget.info);
                  else
                    global.addToFavourite(widget.info);

                  setState(() {
                    isFavourite = !isFavourite;
                  });
                }),
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
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              info.name!,
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
                  child: Image.network(info.image!),
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      centeredListTile('Released', info.released!),
                      centeredListTile('Episode(s)', info.lastEpisode!),
                      ListTile(
                        title: Text('Catagory', textAlign: TextAlign.center),
                        subtitle: FlatButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return CategoryPage(
                                  // The domain will be added later so DON'T ADD IT HERE
                                  url: info.categoryLink,
                                  title: info.category,
                                );
                              }),
                            );
                          },
                          child: Text(
                            info.category!,
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
                    child: Image.network(info.image!),
                  ),
                ),
              ],
            ),
          ),
          SearchAnimeButton(name: widget.info!.name),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: ListTile(
              title: Text('Genre', textAlign: TextAlign.center),
              subtitle: Wrap(
                alignment: WrapAlignment.center,
                spacing: 4,
                children: info.genre.map((e) {
                  return ActionChip(
                    label: Text(e.getAnimeGenreName()),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return GenrePage(genre: e);
                        }),
                      );
                    },
                  );
                }).toList(growable: false),
              ),
            ),
          ),
          centeredListTile('Summary', info.summary ?? 'No summary'),
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
            children: info.episodes.map((e) {
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
                        decoration: currEpisode == e.episodeStart
                            ? TextDecoration.underline
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(growable: false),
          ),
          renderEpisodeList(context),
        ],
      );
    }
  }

  void loadEpisode(EpisodeSection e) {
    // Don't update if the selection is the same
    if (e.episodeStart == this.currEpisode) return;

    setState(() {
      this.currEpisode = e.episodeStart;
      this.loadingEpisode = true;
    });

    final parser =
        EpisodeListParser(global.getDomain() + '/load-list-episode', e);
    parser.downloadHTML().then((body) {
      setState(() {
        this.episodes = parser.parseHTML(body!);
        this.loadingEpisode = false;
      });
    });
  }

  Widget renderEpisodeList(BuildContext context) {
    if (currEpisode == null) {
      return SizedBox.shrink();
    } else if (loadingEpisode) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: this.episodes.map((e) {
            return RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return EpisodePage(info: e);
                }));
              },
              child: Text(e.name!),
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
