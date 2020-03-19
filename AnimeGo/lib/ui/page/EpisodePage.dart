import 'package:AnimeGo/core/Global.dart';
import 'package:AnimeGo/core/Util.dart';
import 'package:AnimeGo/core/model/BasicAnime.dart';
import 'package:AnimeGo/core/model/OneEpisodeInfo.dart';
import 'package:AnimeGo/core/parser/OneEpisodeParser.dart';
import 'package:AnimeGo/ui/page/AnimeDetailPage.dart';
import 'package:AnimeGo/ui/page/CategoryPage.dart';
import 'package:AnimeGo/ui/page/WatchAnimePage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// EpisodePage class
class EpisodePage extends StatefulWidget {
  final BasicAnime info;
  EpisodePage({Key key, @required this.info}) : super(key: key);

  @override
  _EpisodePageState createState() => _EpisodePageState();
}


class _EpisodePageState extends State<EpisodePage> with SingleTickerProviderStateMixin {
  String link;
  OneEpisodeInfo info;
  final global = Global();
  String fomattedName;

  AnimationController controller;
  Animation<double> listScale;
  
  @override
  void initState() {
    super.initState();
    this.controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this, value: 0.0);
    this.listScale = CurvedAnimation(parent: this.controller, curve: Curves.linearToEaseOut);
    this.loadEpisodeInfo(widget.info.link);
  }

  loadEpisodeInfo(String link) {
    setState(() {
      info = null;
    });

    this.controller.reset();
    final parser = OneEpisodeParser(global.getDomain() + link);
    parser.downloadHTML().then((body) {
      setState(() {
        this.info = parser.parseHTML(body);
        this.fomattedName = info.name.split(RegExp(r"[^a-zA-Z0-9]")).join('+');
        this.controller.forward();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          info == null ? 'Loading...' : 'Episode ${info.currentEpisode}',
        )
      ),
      body: info == null ?
      Center(
        child: CircularProgressIndicator(),
      ) :
      ScaleTransition(
        scale: this.listScale,
        child: Center(
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text('Category'),
                subtitle: Text(info.category),
                onTap: () {
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => CategoryPage(
                      url: info.categoryLink, 
                      title: info.category)
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Anime Info'),
                subtitle: Text(info.name),
                onTap: () {
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => AnimeDetailPage(info: info)),
                  );
                },
              ),
              ListTile(
                title: Text('Server List'),
                subtitle: Wrap(
                  children: renderServerList(),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: this.info != null ? 1 : 0,
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: this.info != null ? <Widget>[
              Tooltip(
                message: 'Previous episode',
                child: IconButton(
                  onPressed: this.info.prevEpisode != null ? () {
                    this.loadEpisodeInfo(this.info.prevEpisode);
                  } : null,
                  icon: Icon(Icons.arrow_back),
                ),
              ),
              FlatButton(
                onPressed: () {
                  launch('https://www.google.com/search?q=$fomattedName');
                }, 
                child: Text('Google')
              ),
              FlatButton(
                onPressed: () {
                  launch('https://duckduckgo.com/?q=$fomattedName');
                }, 
                child: Text('DuckDuckGo')
              ),
              Tooltip(
                message: 'Next episode',
                child: IconButton(
                  onPressed: this.info.nextEpisode != null ? () {
                    this.loadEpisodeInfo(this.info.nextEpisode);
                  } : null,
                  icon: Icon(Icons.arrow_forward),
                ),
              ),
            ] : [SizedBox.shrink()],
          ),
        ),
      ),
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
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => WatchAnimePage(video: e), fullscreenDialog: true),
                );
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
}
