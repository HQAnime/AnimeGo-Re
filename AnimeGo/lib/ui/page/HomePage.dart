import 'package:AnimeGo/ui/page/AnimeMenu.dart';
import 'package:AnimeGo/ui/widget/AnimeGoDrawer.dart';
import 'package:flutter/material.dart';

import 'LastestAnime.dart';
import 'AnimeMenu.dart';
import 'SeasonalAnime.dart';

/// HomePage class, it has a bottom navigation and handles tab changes
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Current selected index, used to switch tabs
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Release'),
      ),
      body: Container(),
      drawer: AnimeGoDrawer()
    );
  }
}
