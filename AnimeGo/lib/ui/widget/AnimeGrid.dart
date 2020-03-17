import 'package:AnimeGo/core/Global.dart';
import 'package:AnimeGo/core/model/AnimeInfo.dart';
import 'package:AnimeGo/core/parser/AnimeParser.dart';
import 'package:AnimeGo/ui/widget/AnimeCard.dart';
import 'package:flutter/material.dart';

/// AnimeGrid class
class AnimeGrid extends StatefulWidget {
  final String url;
  AnimeGrid({Key key, @required this.url}) : super(key: key);

  @override
  _AnimeGridState createState() => _AnimeGridState();
}

class _AnimeGridState extends State<AnimeGrid> {
  final global = Global();
  bool loading = true;
  List<AnimeInfo> list = [];
  /// Current page, starting from 1
  int page = 1;

  @override
  void initState() {
    super.initState();
    // Load some data here
    loadData();
  }

  /// Increase page and load more data
  void loadData() {
    final link = global.getDomain() + widget.url + '?page=$page';
    print('Current link is $link');
    final parser = AnimeParser(link);
    parser.downloadHTML().then((body) {
      final moreData = parser.parseHTML(body);
      // Append more data
      setState(() {
        this.loading = false;
        this.list += moreData;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (loading) {
      // While loading, show a loading indicator and a normal app bar
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      // After parsing is done, show the anime grid
      return SafeArea(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.5,
          ), 
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                child: AnimeCard(info: this.list[index]),
                onTap: () {},
              )
            );
          },
          itemCount: this.list.length,
        ),
      );
    }
  }
}
