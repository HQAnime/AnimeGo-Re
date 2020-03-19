import 'package:AnimeGo/core/model/AnimeInfo.dart';
import 'package:flutter/material.dart';

/// AnimeCard class
class AnimeCard extends StatelessWidget {
  final AnimeInfo info;
  AnimeCard({Key key, @required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Watch ${info.name}',
      child: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.7,
            child: FittedBox(
              child: Image.network(info.coverImage),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              info.name,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500),
              maxLines: 2,
            ),
          ),
          Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 24,
              color: Colors.blue,
              child: Center(
                child: Text(
                  info.episode,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
