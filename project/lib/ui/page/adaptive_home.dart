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
                Center(
                  child: Text('AdaptiveHomePage'),
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
      labelType: NavigationRailLabelType.selected,
      destinations: [
        for (final item in _navigationItems)
          NavigationRailDestination(
            icon: Icon(item.icon),
            label: Text(item.title),
          ),
      ],
      selectedIndex: 0,
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
            )
        ],
      ),
    );
  }
}
