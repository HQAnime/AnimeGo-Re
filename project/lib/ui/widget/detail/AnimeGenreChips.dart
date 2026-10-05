import 'package:animego/core/model/AnimeGenre.dart';
import 'package:flutter/material.dart';

/// A centered list of genre chips for the anime detail page.
class AnimeGenreChips extends StatelessWidget {
  const AnimeGenreChips({
    Key? key,
    required this.genres,
    required this.onTap,
  }) : super(key: key);

  final List<AnimeGenre> genres;
  final void Function(AnimeGenre genre) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ListTile(
        title: Text('Genre', textAlign: TextAlign.center),
        subtitle: Wrap(
          alignment: WrapAlignment.center,
          spacing: 4,
          children: genres
              .map(
                (genre) => ActionChip(
                  label: Text(genre.getAnimeGenreName()),
                  onPressed: () => onTap(genre),
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
  }
}
