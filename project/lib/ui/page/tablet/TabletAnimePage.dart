import 'package:animego/core/model/AnimeInfo.dart';
import 'package:animego/core/model/BasicAnime.dart';
import 'package:animego/core/model/EpisodelInfo.dart';
import 'package:animego/core/model/OneEpisodeInfo.dart';
import 'package:animego/ui/page/AnimeDetailPage.dart';
import 'package:animego/ui/page/EpisodePage.dart';
import 'package:flutter/material.dart';

/// A combination of AnimeDetail and Episode page
class TabletAnimePage extends StatefulWidget {
  const TabletAnimePage({
    Key? key,
    required this.info,
  }) : super(key: key);

  final BasicAnime info;

  @override
  _TabletAnimePageState createState() => _TabletAnimePageState();
}

class _TabletAnimePageState extends State<TabletAnimePage> {
  BasicAnime? animeDetail;
  BasicAnime? episode;

  @override
  void initState() {
    super.initState();
    if (widget.info.isCategory) {
      animeDetail = widget.info;
    } else if (widget.info.isEpisode) {
      episode = widget.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Flexible(
            flex: 1,
            child: _renderAnimeDetail(),
          ),
          Flexible(
            flex: 1,
            // need to send data back here
            child: _renderEpisode(),
          ),
        ],
      ),
    );
  }

  _renderAnimeDetail() {
    if (animeDetail == null) {
      // The AppBar here is needed to go back to the previous page
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return AnimeDetailPage(
      info: animeDetail,
      embedded: true,
    );
  }

  _renderEpisode() {
    if (episode == null) {
      // TODO: maybe add an AppBar here as well? I don't know
      return Container();
    }

    return EpisodePage(
      info: episode,
      embedded: true,
      onEpisodeInfoLoaded: onUpdateAnimeDetail,
    );
  }

  /// When a new episode is selected from anime detail, update the episode page
  onUpdateEpisode(EpisodeInfo? info) {
    setState(() {});
  }

  /// When the episode page is loaded, load the anime detail page
  onUpdateAnimeDetail(OneEpisodeInfo? info) {
    setState(() {
      this.animeDetail = info;
    });
  }
}
