import 'package:AnimeGo/ui/widget/AnimeGrid.dart';
import 'package:flutter/material.dart';

/// CategoryPage class
class CategoryPage extends StatelessWidget {
  final String url;
  final String title;
  CategoryPage({Key key, @required this.url, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: AnimeGrid(url: url),
    );
  }
}
