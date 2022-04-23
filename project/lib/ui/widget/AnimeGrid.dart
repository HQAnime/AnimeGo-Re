import 'dart:math';

import 'package:animego/core/Global.dart';
import 'package:animego/core/Util.dart';
import 'package:animego/core/model/AnimeInfo.dart';
import 'package:animego/core/parser/AnimeParser.dart';
import 'package:animego/ui/page/AnimeDetailPage.dart';
import 'package:animego/ui/page/EpisodePage.dart';
import 'package:animego/ui/page/tablet/TabletAnimePage.dart';
import 'package:animego/ui/widget/AnimeCard.dart';
import 'package:animego/ui/widget/LoadingSwitcher.dart';
import 'package:flutter/material.dart';

/// AnimeGrid class
class AnimeGrid extends StatefulWidget {
  const AnimeGrid({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String? url;

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

  late ScrollController controller;
  bool showIndicator = false;

  @override
  void initState() {
    super.initState();
    // Load some data here
    loadData();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      this.controller = ScrollController(initialScrollOffset: 0)
        ..addListener(() => this.loadMoreData());
    });
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
    // Reset page to 1, start from 1 not ZERO
    if (refresh) page = 1;

    setState(() {
      canLoadMore = false;
      showIndicator = true;
    });

    bool isSearch = widget.url?.startsWith('/search') ?? false;
    // For search, you need to use &
    final link = global.getDomain() +
        widget.url! +
        (isSearch ? '&' : '?') +
        'page=$page';
    print('Current link is $link');
    final parser = AnimeParser(link);
    parser.downloadHTML().then((body) {
      final moreData = parser.parseHTML(body);

      // Filter out dub
      if (global.hideDUB ?? false) moreData.removeWhere((e) => e.isDUB);

      // Append more data
      if (mounted) {
        setState(() {
          this.loading = false;
          // If refresh, just reset the list to more data
          if (refresh)
            this.list = moreData;
          else
            this.list += moreData;
          // If more data is emptp, we have reached the end
          this.canLoadMore = moreData.length > 0;
          this.showIndicator = false;
        });
      } else {
        print('WARNING: AnimeGrid is setting state after the view is disposed');
      }
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
                controller: controller,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final count =
                        max(min((constraints.maxWidth / 200).floor(), 7), 2);
                    final imageWidth = constraints.maxWidth / count.toDouble();
                    // Calculat ratio, adjust the offset (70)
                    final ratio = imageWidth / (imageWidth / 0.7 + 70);
                    final length = this.list.length;

                    return length > 0
                        ? GridView.builder(
                            controller: this.controller,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
                                      Util.platformPageRoute(
                                          builder: (context) {
                                        if (info.isCategory) {
                                          if (Util(context).isTablet())
                                            return TabletAnimePage(info: info);
                                          return AnimeDetailPage(info: info);
                                        }

                                        if (Util(context).isTablet())
                                          return TabletAnimePage(info: info);
                                        return EpisodePage(info: info);
                                      }),
                                    );
                                  },
                                ),
                              );
                            },
                            itemCount: length,
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Nothing was found. Try loading it again.\nDouble check the website link in Settings as well.',
                                  textAlign: TextAlign.center,
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      loading = true;
                                    });
                                    loadData(refresh: true);
                                  },
                                  icon: Icon(Icons.refresh),
                                ),
                              ],
                            ),
                          );
                  },
                ),
              ),
            ),
            showIndicator
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: LinearProgressIndicator(),
                  )
                : Container(),
          ],
        ),
      );
    }
  }
}
