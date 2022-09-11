import 'package:animego/core/Firebase.dart';
import 'package:animego/core/Util.dart';
import 'package:animego/ui/page/Favourite.dart';
import 'package:animego/ui/page/History.dart';
import 'package:animego/ui/page/Movie.dart';
import 'package:animego/ui/page/PopularAnime.dart';
import 'package:animego/ui/page/SeasonalAnime.dart';
import 'package:animego/ui/page/Settings.dart';
import 'package:animego/ui/widget/GenreList.dart';
import 'package:flutter/material.dart';

/// AnimeDrawer class
class AnimeDrawer extends StatefulWidget {
  const AnimeDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<AnimeDrawer> createState() => _AnimeDrawerState();
}

class _AnimeDrawerState extends State<AnimeDrawer> {
  @override
  void initState() {
    super.initState();
    FirebaseEventService().logFabMenu();
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = Util(context).isDarkMode();

    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              // Use black instead orange to not hurt users' eyes at night
              color: darkMode ? Colors.black38 : Colors.deepOrange,
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'AnimeGo Re',
                style: TextStyle(
                  fontSize: 32,
                  // Different colour for dark mode
                  color: darkMode ? Colors.orange : Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Expanded(
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: const Text('Seasonal'),
                    leading: const Icon(Icons.fiber_new),
                    onTap: () => push(
                      context,
                      const SeasonalAnime(),
                    ),
                  ),
                  ListTile(
                    title: const Text('Movie'),
                    leading: const Icon(Icons.movie),
                    onTap: () => push(
                      context,
                      const Movie(),
                    ),
                  ),
                  ListTile(
                    title: const Text('Popular'),
                    leading: const Icon(Icons.label),
                    onTap: () => push(
                      context,
                      const PopularAnime(),
                    ),
                  ),
                  ExpansionTile(
                    title: const Text('Genre'),
                    leading: const Icon(Icons.list),
                    children: <Widget>[GenreList()],
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('History'),
                    leading: const Icon(Icons.history),
                    onTap: () => push(
                      context,
                      const History(),
                    ),
                  ),
                  ListTile(
                    title: const Text('Favourite'),
                    leading: const Icon(Icons.favorite),
                    onTap: () => push(
                      context,
                      const Favourite(),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Settings'),
                    leading: const Icon(Icons.settings),
                    onTap: () => push(
                      context,
                      const Settings(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Push to new screen and also remove all routes in the middle
  void push(BuildContext context, Widget screen) {
    // Pop the drawer
    Navigator.pop(context);
    // How to push to new screen?
    Navigator.push(
      context,
      Util.platformPageRoute(builder: (context) => screen),
    );
  }
}
