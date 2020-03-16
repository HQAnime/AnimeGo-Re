import 'package:flutter/material.dart';

/// AnimeGrid class
class AnimeGrid extends StatefulWidget {
  final url;
  AnimeGrid({Key key, @required this.url}) : super(key: key);

  @override
  _AnimeGridState createState() => _AnimeGridState();
}


class _AnimeGridState extends State<AnimeGrid> {
  bool loading = true;
  int page = 0;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Text('Hello World');
    }
  }
}
