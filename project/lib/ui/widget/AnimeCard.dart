import 'package:animego/core/model/AnimeInfo.dart';
import 'package:flutter/material.dart';

/// AnimeCard class
class AnimeCard extends StatelessWidget {
  const AnimeCard({
    Key? key,
    required this.info,
  }) : super(key: key);

  final AnimeInfo info;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Watch ${info.name}',
      child: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.7,
            child: Ink(
              decoration: BoxDecoration(
                image: info.coverImage != null
                    ? DecorationImage(
                        image: NetworkImage(info.coverImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              info.name ?? 'Unknown',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
              maxLines: 2,
            ),
          ),
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 24,
              color: Colors.blue,
              child: Center(
                child: Text(
                  info.episode ?? '??',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
