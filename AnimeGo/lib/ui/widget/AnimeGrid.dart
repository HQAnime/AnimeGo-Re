import 'dart:math';

import 'package:AnimeGo/core/Global.dart';
import 'package:AnimeGo/core/model/AnimeInfo.dart';
import 'package:AnimeGo/core/parser/AnimeParser.dart';
import 'package:AnimeGo/ui/page/AnimeDetailPage.dart';
import 'package:AnimeGo/ui/page/EpisodePage.dart';
import 'package:AnimeGo/ui/widget/AnimeCard.dart';
import 'package:AnimeGo/ui/widget/LoadingSwitcher.dart';
import 'package:flutter/material.dart';

/// AnimeGrid class
class AnimeGrid extends StatefulWidget {
  final String url;
  AnimeGrid({Key key, @required this.url}) : super(key: key);

  @override
  _AnimeGridState createState() => _AnimeGridState();
}

class _AnimeGridState extends State<AnimeGrid> {
  final global = Global();

  bool loading = true;
  List<AnimeInfo> list = [];
  /// Current page, starting from 1
  int page = 1;
  bool canLoadMore = true;

  ScrollController controller;
  bool showIndicator = false;

  @override
  void initState() {
    super.initState();
    // Load some data here
    loadData();
    this.controller = ScrollController()..addListener(() => this.loadMoreData());
  }

  @override
  void didChangeDependencies() {
    print(widget.url);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    this.controller.dispose();
    super.dispose();
  }

  /// Increase page and load more data
  void loadData({bool refresh = false}) {
    // Reset page to 0
    if (refresh) page = 0;

    setState(() {
      canLoadMore = false;
      showIndicator = true;
    });

    bool isSearch = widget.url.startsWith('/search');
    // For search, you need to use &
    final link = global.getDomain() + widget.url + (isSearch ? '&' : '?') + 'page=$page';
    print('Current link is $link');
    final parser = AnimeParser(link);
    parser.downloadHTML().then((body) {
      final moreData = parser.parseHTML(body);
      // Append more data
      setState(() {
        this.loading = false;
        // If refresh, just reset the list to more data
        if (refresh) this.list = moreData;
        else this.list += moreData;
        // If more data is emptp, we have reached the end
        this.canLoadMore = moreData.length > 0;
        this.showIndicator = false;
      });
    });
  }

  /// Load more data if the grid is close to the end
  void loadMoreData() {
    if (controller.position.extentAfter < 10 && canLoadMore) {
      print('Loading new data');
      this.page += 1;
      this.loadData();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return LoadingSwitcher(
      loading: this.loading, 
      child: this.renderBody(),
    );
  }

  Widget renderBody() {
    if (loading) {
      // While loading, show a loading indicator and a normal app bar
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      // After parsing is done, show the anime grid
      return SafeArea(
        child: Stack(
          children: <Widget>[
            RefreshIndicator(
              onRefresh: () async {
                this.loadData(refresh: true);
              },
              child: Scrollbar(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final count = max(min((constraints.maxWidth / 200).floor(), 5), 2);
                    final imageWidth = constraints.maxWidth / count.toDouble();
                    // Calculat ratio, adjust the offset (70)
                    final ratio = imageWidth / (imageWidth / 0.7 + 70);

                    return GridView.builder(
                      controller: this.controller,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: count,
                        childAspectRatio: ratio,
                      ), 
                      itemBuilder: (BuildContext context, int index) {
                        final info = this.list[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            child: AnimeCard(info: info),
                            onTap: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) {
                                  if (info.isCategory()) return AnimeDetailPage(info: info);
                                  return EpisodePage(info: info);
                                })
                              );
                            } 
                          )
                        );
                      },
                      itemCount: this.list.length,
                    );
                  },
                ),
              ),
            ),
            showIndicator ? 
            Align(
              alignment: Alignment.bottomCenter,
              child: LinearProgressIndicator(),
            ) : 
            SizedBox.shrink(),
          ],
        ),
      );
    }
  }
}
