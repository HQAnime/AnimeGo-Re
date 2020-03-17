import 'package:flutter/material.dart';

/// AnimeGrid class
class AnimeGrid extends StatefulWidget {
  final String url;
  final String title;
  AnimeGrid({Key key, @required this.title, @required this.url}) : super(key: key);

  @override
  _AnimeGridState createState() => _AnimeGridState();
}


class _AnimeGridState extends State<AnimeGrid> {
  bool loading = true;
  /// Current page, starting from 1
  int page = 1;
  
  @override
  Widget build(BuildContext context) {
    if (loading) {
      // While loading, show a loading indicator and a normal app bar
      return Column(
        children: <Widget>[
          AppBar(
            title: Text(widget.title)
          ),
          Expanded(
            child: Center(
              child: CircularProgressIndicator()
            ),
          )
        ],
      );
    } else {
      // After parsing is done, show the anime grid
      return CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(widget.title),
            floating: true,
            forceElevated: true,
          ),
        ],
      );
    }
  }
}
