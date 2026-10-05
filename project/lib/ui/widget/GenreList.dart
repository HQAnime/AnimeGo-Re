import 'package:animego/core/model/AnimeGenre.dart';
import 'package:animego/ui/page/GenrePage.dart';
import 'package:animego/ui/widget/AnimeFlatButton.dart';
import 'package:flutter/material.dart';

/// The full genre list, rendered as tappable chips.
class GenreList extends StatelessWidget {
  const GenreList({Key? key}) : super(key: key);

  /// Every genre the app supports, all in one place.
  static const genreList = <String>[
    'Action',
    'Adventure',
    'Cars',
    'Comedy',
    'Dementia',
    'Demons',
    'Drama',
    'Ecchi',
    'Fantasy',
    'Game',
    'Harem',
    'Historical',
    'Horror',
    'Josei',
    'Kids',
    'Magic',
    'Martial Arts',
    'Mecha',
    'Military',
    'Music',
    'Mystery',
    'Parody',
    'Police',
    'Psychological',
    'Romance',
    'Samurai',
    'School',
    'Sci-Fi',
    'Seinen',
    'Shoujo',
    'Shoujo Ai',
    'Shounen',
    'Shounen Ai',
    'Slice of Life',
    'Space',
    'Sports',
    'Super Power',
    'Supernatural',
    'Thriller',
    'Vampire',
    'Yaoi',
    'Yuri',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      children: renderGenres(context),
    );
  }

  /// Render all genres as chips that open the matching [GenrePage].
  List<Widget> renderGenres(BuildContext context) {
    return genreList
        .map(
          (item) => AnimeFlatButton(
            child: Text(item),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenrePage(genre: AnimeGenre(item)),
                ),
              );
            },
          ),
        )
        .toList(growable: false);
  }
}
