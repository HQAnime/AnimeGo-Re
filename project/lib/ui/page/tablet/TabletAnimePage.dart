import 'package:animego/core/Firebase.dart';
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

  final BasicAnime? info;

  @override
  _TabletAnimePageState createState() => _TabletAnimePageState();
}

class _TabletAnimePageState extends State<TabletAnimePage> {
  BasicAnime? animeDetail;
  BasicAnime? episode;

  @override
  void initState() {
    super.initState();
    assert(widget.info != null, 'Anime info must not be null');

    if (widget.info?.isCategory ?? false) {
      animeDetail = widget.info;
    } else if (widget.info?.isEpisode ?? false) {
      episode = widget.info;
    }

    FirebaseEventService().logUseTabletPage();
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
      onEpisodeSelected: onUpdateEpisode,
    );
  }

  _renderEpisode() {
    if (episode == null) {
      return Center(
        child: Text('Pick an episode from the list'),
      );
    }

    return EpisodePage(
      key: Key(episode?.link ?? ''),
      info: episode,
      embedded: true,
      onEpisodeInfoLoaded: onUpdateAnimeDetail,
    );
  }

  /// When a new episode is selected from anime detail, update the episode page
  onUpdateEpisode(EpisodeInfo? info) {
    if (info?.link == episode?.link) return;
    setState(() {
      this.episode = info;
    });
  }

  /// When the episode page is loaded, load the anime detail page
  onUpdateAnimeDetail(OneEpisodeInfo? info) {
    setState(() {
      this.animeDetail = info;
    });
  }
}