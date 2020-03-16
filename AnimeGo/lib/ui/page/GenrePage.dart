import 'package:AnimeGo/ui/widget/GenreList.dart';
import 'package:flutter/material.dart';

/// GenrePage class
class GenrePage extends StatelessWidget {
  GenrePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Genre')
      ),
      body: GenreList(),
    );
  }
}
