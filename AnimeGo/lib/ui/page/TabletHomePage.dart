import 'package:AnimeGo/ui/page/CategoryPage.dart';
import 'package:AnimeGo/ui/widget/AnimeDrawer.dart';
import 'package:flutter/material.dart';

/// TabletHomePage class
class TabletHomePage extends StatefulWidget {
  TabletHomePage({Key key}) : super(key: key);

  @override
  _TabletHomePageState createState() => _TabletHomePageState();
}


class _TabletHomePageState extends State<TabletHomePage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: AnimeDrawer(),
        ),
        Flexible(
          flex: 3,
          child: CategoryPage(title: 'Latest', url: '/page-recent-release.html',),
        ),
      ],
    );
  }
}
