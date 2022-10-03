import 'package:animego/core/Util.dart';
import 'package:animego/ui/page/Favourite.dart';
import 'package:animego/ui/page/History.dart';
import 'package:animego/ui/page/SearchAnime.dart';
import 'package:animego/ui/page/SeasonalAnime.dart';
import 'package:animego/ui/page/Settings.dart';
import 'package:animego/ui/widget/AnimeGrid.dart';
import 'package:flutter/material.dart';

enum _PageCode {
  latest,
  seasonal,
  movie,
  popular,
  genre,
  history,
  favourite,
  setting,
}

/// A holder for both navigation rail and the drawer
class _NavigationItem {
  const _NavigationItem({
    required this.code,
    required this.title,
    required this.icon,
  });

  final _PageCode code;
  final String title;
  final IconData icon;
}

const _navigationItems = [
  _NavigationItem(
    code: _PageCode.latest,
    title: 'Latest',
    icon: Icons.home,
  ),
  _NavigationItem(
    code: _PageCode.seasonal,
    title: 'Seasonal',
    icon: Icons.calendar_today,
  ),
  _NavigationItem(
    code: _PageCode.movie,
    title: 'Movie',
    icon: Icons.movie,
  ),
  _NavigationItem(
      code: _PageCode.popular, title: 'Popular', icon: Icons.whatshot),
  _NavigationItem(
    code: _PageCode.genre,
    title: 'Genre',
    icon: Icons.category,
  ),
  _NavigationItem(
    code: _PageCode.history,
    title: 'History',
    icon: Icons.history,
  ),
  _NavigationItem(
    code: _PageCode.favourite,
    title: 'Favourite',
    icon: Icons.favorite,
  ),
  _NavigationItem(
    code: _PageCode.setting,
    title: 'Settings',
    icon: Icons.settings,
  ),
];

class AdaptiveHomePage extends StatefulWidget {
  const AdaptiveHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<AdaptiveHomePage> createState() => _AdaptiveHomePageState();
}

class _AdaptiveHomePageState extends State<AdaptiveHomePage> {
  _PageCode _selectedPage = _PageCode.latest;

  final _pageList = [
    _LazyAliveWidget(
      // key: Key(_PageCode.latest.toString()),
      child: AnimeGrid(
        url: '/page-recent-release.html',
      ),
    ),
    _LazyAliveWidget(
      // key: Key(_PageCode.seasonal.toString()),
      child: SeasonalAnime(
        embedded: true,
      ),
    ),
    _LazyAliveWidget(
      // key: Key(_PageCode.movie.toString()),
      child: AnimeGrid(
        url: '/anime-movies.html',
      ),
    ),
    _LazyAliveWidget(
      // key: Key(_PageCode.popular.toString()),
      child: AnimeGrid(
        url: '/popular.html',
      ),
    ),
    _LazyAliveWidget(
      child: AnimeGrid(url: '/popular.html'),
    ),
    History(embedded: true),
    Favourite(embedded: true),
    const Settings(embedded: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _renderDrawer(),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('AnimeGo'),
            ),
            drawer: _renderDrawer(),
            body: Row(
              children: [
                _renderRail(),
                Expanded(
                  child: _renderPage(),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  Util.platformPageRoute(builder: (context) {
                    return SearchAnime();
                  }),
                );
              },
              child: const Icon(Icons.search),
            ),
          ),
        ),
      ],
    );
  }

  NavigationRail _renderRail() {
    return NavigationRail(
      labelType: NavigationRailLabelType.all,
      destinations: [
        for (final item in _navigationItems)
          NavigationRailDestination(
            icon: Icon(item.icon),
            label: Text(item.title),
          ),
      ],
      leading: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            Util.platformPageRoute(builder: (context) {
              return SearchAnime();
            }),
          );
        },
        child: const Icon(Icons.search),
      ),
      selectedIndex: _selectedPage.index,
      onDestinationSelected: (value) => setState(() {
        _selectedPage = _navigationItems[value].code;
      }),
    );
  }

  Drawer _renderDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text('Drawer Header')),
          // render a search button aligned to the left
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  Util.platformPageRoute(builder: (context) {
                    return SearchAnime();
                  }),
                );
              },
              icon: const Icon(Icons.search),
              label: const Text('Search'),
            ),
          ),
          for (final item in _navigationItems)
            ListTile(
              leading: Icon(item.icon),
              title: Text(item.title),
              selected: _selectedPage == item.code,
              onTap: () => setState(() => _selectedPage = item.code),
            )
        ],
      ),
    );
  }

  Widget _renderPage() {
    final page = _pageList[_selectedPage.index];
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: page,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      layoutBuilder: (currentChild, previousChildren) => currentChild!,
    );
  }
}

class _LazyAliveWidget extends StatefulWidget {
  const _LazyAliveWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<_LazyAliveWidget> createState() => _LazyAliveWidgetState();
}

class _LazyAliveWidgetState extends State<_LazyAliveWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
