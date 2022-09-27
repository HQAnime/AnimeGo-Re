import 'package:animego/ui/page/Favourite.dart';
import 'package:animego/ui/page/History.dart';
import 'package:animego/ui/page/SeasonalAnime.dart';
import 'package:animego/ui/page/Settings.dart';
import 'package:animego/ui/widget/AnimeGrid.dart';
import 'package:flutter/material.dart';

class AdaptiveHomePage extends StatefulWidget {
  const AdaptiveHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<AdaptiveHomePage> createState() => _AdaptiveHomePageState();
}

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

class _AdaptiveHomePageState extends State<AdaptiveHomePage> {
  _PageCode _selectedPage = _PageCode.latest;

  // switch (code) {
  //     case PageCode.latest:
  //       return AnimeGrid(
  //         url: '/page-recent-release.html',
  //         key: Key(code.toString()),
  //       );
  //     case PageCode.seasonal:
  //       return SeasonalAnime(embedded: true, key: Key(code.toString()));
  //     case PageCode.movie:
  //       return AnimeGrid(url: '/anime-movies.html', key: Key(code.toString()));
  //     case PageCode.popular:
  //       return AnimeGrid(url: '/popular.html', key: Key(code.toString()));
  //     case PageCode.genre:
  //       return AnimeGrid(url: genre, key: Key(genre));
  //     case PageCode.history:
  //       return const History(embedded: true);
  //     case PageCode.favourite:
  //       return const Favourite(embedded: true);
  //     case PageCode.setting:
  //       return const Settings(embedded: true);
  //     default:
  //       assert(false, 'Unknown page code');
  //       return Container();
  //   }

  final _pages = <_PageCode, Widget>{
    _PageCode.latest: AnimeGrid(
      url: '/page-recent-release.html',
      key: Key(_PageCode.latest.toString()),
    ),
    _PageCode.seasonal: SeasonalAnime(
      embedded: true,
      key: Key(_PageCode.seasonal.toString()),
    ),
    _PageCode.movie: AnimeGrid(
      url: '/anime-movies.html',
      key: Key(_PageCode.movie.toString()),
    ),
    _PageCode.popular: AnimeGrid(
      url: '/popular.html',
      key: Key(_PageCode.popular.toString()),
    ),
    _PageCode.genre: AnimeGrid(url: '/popular.html'),
    _PageCode.history: const History(embedded: true),
    _PageCode.favourite: const Favourite(embedded: true),
    _PageCode.setting: const Settings(embedded: true),
  };

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
          ),
        ),
      ],
    );
  }

  NavigationRail _renderRail() {
    return NavigationRail(
      labelType: NavigationRailLabelType.all,
      // leading: Image.asset(
      //   'assets/images/placeholder.png',
      //   width: 48,
      //   height: 48,
      // ),
      destinations: [
        for (final item in _navigationItems)
          NavigationRailDestination(
            icon: Icon(item.icon),
            label: Text(item.title),
          ),
      ],
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
          for (final item in _navigationItems)
            ListTile(
              leading: Icon(item.icon),
              title: Text(item.title),
              selected: _PageCode == item.code,
              onTap: () => setState(() => _selectedPage = item.code),
            )
        ],
      ),
    );
  }

  Widget _renderPage() {
    final page = _pages[_selectedPage];
    return page ?? const Text('Page not found');
  }
}
