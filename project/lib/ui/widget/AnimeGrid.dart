import 'dart:math';

import 'package:animego/core/Global.dart';
import 'package:animego/core/http/CloudflareManager.dart';
import 'package:animego/core/model/AnimeInfo.dart';
import 'package:animego/core/source/AnimeSource.dart';
import 'package:animego/core/source/SourceManager.dart';
import 'package:animego/ui/page/AnimeDetailPage.dart';
import 'package:animego/ui/page/EpisodePage.dart';
import 'package:animego/ui/widget/AnimeCard.dart';
import 'package:animego/ui/widget/LoadingSwitcher.dart';
import 'package:animego/ui/widget/TorrentSheet.dart';
import 'package:flutter/material.dart';

/// AnimeGrid class
class AnimeGrid extends StatefulWidget {
  const AnimeGrid({
    Key? key,
    required this.loadPage,
  }) : super(key: key);

  /// Loads a single page of anime from the active source.
  final Future<List<AnimeInfo>> Function(int page) loadPage;

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
    this.controller = ScrollController()
      ..addListener(() => this.loadMoreData());
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

    widget.loadPage(page).then((moreData) {
      // The page can be popped before the request finishes.
      if (!mounted) return;

      // Filter out dub
      if (global.hideDUB ?? false) moreData.removeWhere((e) => e.isDUB);

      // Append more data
      setState(() {
        this.loading = false;
        // If refresh, just reset the list to more data
        if (refresh)
          this.list = moreData;
        else
          this.list += moreData;
        // If more data is emptp, we have reached the end
        this.canLoadMore = moreData.isNotEmpty;
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

  /// Run the native Cloudflare check, then reload this page.
  Future<void> _verifyAccess() async {
    final source = SourceManager().active;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ok = await CloudflareManager().verify(
      source.id,
      source.baseUrl,
      dark: dark,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? 'Access verified' : 'Verification failed')),
    );
    if (ok) {
      setState(() {
        loading = true;
      });
      loadData(refresh: true);
    }
  }

  /// Torrent results read much better as rows than as poster cards.
  Widget _buildTorrentList() {
    return ListView.separated(
      controller: this.controller,
      itemCount: this.list.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final info = this.list[index];
        return ListTile(
          leading: const Icon(Icons.movie_filter_outlined),
          title: Text(
            info.name ?? 'Unknown',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: (info.episode == null || info.episode!.isEmpty)
              ? null
              : Text(info.episode!),
          trailing: const Icon(Icons.open_in_new),
          onTap: () => showTorrentSheet(context, info),
        );
      },
    );
  }

  /// Open a browse/search result: torrents hand off to the magnet sheet,
  /// streaming anime open the detail or episode page.
  void _open(AnimeInfo info) {
    if (SourceManager().active.kind == SourceKind.torrent) {
      showTorrentSheet(context, info);
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        if (info.isCategory()) return AnimeDetailPage(info: info);
        return EpisodePage(info: info);
      }),
    );
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
                controller: this.controller,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final count =
                        max(min((constraints.maxWidth / 200).floor(), 5), 2);
                    final imageWidth = constraints.maxWidth / count.toDouble();
                    // Calculat ratio, adjust the offset (70)
                    final ratio = imageWidth / (imageWidth / 0.7 + 70);
                    final length = this.list.length;
                    final isTorrent =
                        SourceManager().active.kind == SourceKind.torrent;

                    return length > 0
                        ? (isTorrent
                            ? _buildTorrentList()
                            : GridView.builder(
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
                                      onTap: () => _open(info),
                                    ),
                                  );
                                },
                                itemCount: length,
                              ))
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Nothing was found. Try loading it again.\nDouble check the source and website link in Settings as well.',
                                  textAlign: TextAlign.center,
                                ),
                                if (SourceManager().active.requiresCloudflare &&
                                    CloudflareManager().isSupported)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: FilledButton.icon(
                                      icon: const Icon(Icons.verified_user),
                                      label: const Text('Verify site access'),
                                      onPressed: _verifyAccess,
                                    ),
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
