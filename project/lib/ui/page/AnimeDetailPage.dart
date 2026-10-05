import 'package:animego/core/Firebase.dart';
import 'package:animego/core/Global.dart';
import 'package:animego/core/model/AnimeDetailedInfo.dart';
import 'package:animego/core/model/AnimeGenre.dart';
import 'package:animego/core/model/BasicAnime.dart';
import 'package:animego/core/model/EpisodeSection.dart';
import 'package:animego/core/model/EpisodelInfo.dart';
import 'package:animego/core/source/SourceManager.dart';
import 'package:animego/ui/page/CategoryPage.dart';
import 'package:animego/ui/page/EpisodePage.dart';
import 'package:animego/ui/page/GenrePage.dart';
import 'package:animego/ui/widget/LoadingSwitcher.dart';
import 'package:animego/ui/widget/SearchAnimeButton.dart';
import 'package:animego/ui/widget/detail/AnimeDetailHeader.dart';
import 'package:animego/ui/widget/detail/AnimeGenreChips.dart';
import 'package:animego/ui/widget/detail/EpisodeButtonList.dart';
import 'package:animego/ui/widget/detail/EpisodeSectionChips.dart';
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
  AnimeDetailedInfo? info;
  List<EpisodeInfo> episodes = [];
  final global = Global();

  bool isFavourite = false;

  @override
  void initState() {
    super.initState();

    FirebaseEventService().logUseAnimeInfo();

    // Load data here
    final target = widget.info;
    if (target == null) {
      setState(() {
        this.loading = false;
      });
      return;
    }
    SourceManager().detailWithFallback(target).then((detail) {
      setState(() {
        this.loading = false;
        this.info = detail;
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
    return Scaffold(
      appBar: AppBar(
        title: Text(loading ? 'Loading...' : info?.status ?? 'Error'),
        actions: <Widget>[
          if (!loading && info != null)
            IconButton(
              icon: Icon(
                isFavourite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: toggleFavourite,
            ),
        ],
      ),
      body: SafeArea(
        child: LoadingSwitcher(
          child: this.renderBody(),
          loading: this.loading,
        ),
      ),
    );
  }

  Widget renderBody() {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView(
      children: <Widget>[
        AnimeDetailHeader(
          info: info,
          onCategoryTap: openCategory,
        ),
        SearchAnimeButton(name: widget.info?.name),
        AnimeGenreChips(
          genres: info?.genre ?? [],
          onTap: openGenre,
        ),
        _summaryTile(),
        _episodeListTitle(),
        EpisodeSectionChips(
          sections: info?.episodes ?? [],
          selected: currEpisode,
          enabled: !loadingEpisode,
          onTap: loadEpisode,
        ),
        _episodeButtons(),
      ],
    );
  }

  Widget _summaryTile() {
    return ListTile(
      title: Text('Summary', textAlign: TextAlign.center),
      subtitle: Text(
        info?.summary ?? 'No summary',
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _episodeListTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        'Episode List',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _episodeButtons() {
    if (currEpisode == null) {
      return Container();
    }
    if (loadingEpisode) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return EpisodeButtonList(
      episodes: episodes,
      onTap: (episode) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return EpisodePage(info: episode);
        }),
      ),
    );
  }

  void toggleFavourite() {
    FirebaseEventService().logUseFavourite();
    if (isFavourite)
      global.removeFromFavourite(widget.info);
    else
      global.addToFavourite(widget.info);

    setState(() {
      isFavourite = !isFavourite;
    });
  }

  void openCategory() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        return CategoryPage(
          url: info?.categoryLink,
          title: info?.category,
        );
      }),
    );
  }

  void openGenre(AnimeGenre genre) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return GenrePage(genre: genre);
      }),
    );
  }

  void loadEpisode(EpisodeSection? e) {
    // Don't update if the selection is the same
    if (e?.episodeStart == this.currEpisode) return;

    setState(() {
      this.currEpisode = e?.episodeStart;
      this.loadingEpisode = true;
    });

    FirebaseEventService().logUseEpisodeList();

    if (e == null) return;
    SourceManager().active.episodes(e).then((list) {
      setState(() {
        this.episodes = list;
        this.loadingEpisode = false;
      });
    });
  }
}
