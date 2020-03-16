import 'package:flutter/material.dart';

/// AnimeGrid class
class AnimeGrid extends StatefulWidget {
  AnimeGrid({Key key}) : super(key: key);

  @override
  _AnimeGridState createState() => _AnimeGridState();
}


class _AnimeGridState extends State<AnimeGrid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AnimeGrid')
      ),
      body: Container(),
    );
  }
}
