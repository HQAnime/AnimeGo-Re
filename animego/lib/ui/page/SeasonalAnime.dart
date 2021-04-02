import 'package:animego/ui/widget/AnimeGrid.dart';
import 'package:flutter/material.dart';

/// SeasonalAnime class
class SeasonalAnime extends StatefulWidget {
  const SeasonalAnime({
    Key? key,
  }) : super(key: key);

  @override
  _SeasonalAnimeState createState() => _SeasonalAnimeState();
}

class _SeasonalAnimeState extends State<SeasonalAnime> {
  static const SEASONS = ['winter', 'spring', 'summer', 'fall'];
  String url = '/new-season.html';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Season')),
      body: Column(
        children: [
          buildPastSeasons(),
          Expanded(child: AnimeGrid(url: this.url, key: Key(this.url))),
        ],
      ),
    );
  }

  Widget buildPastSeasons() {
    final pastSeasons = _getSeasonList();
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: pastSeasons.length,
        itemBuilder: (context, index) {
          // Get current filter
          final filter = pastSeasons[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
            child: ActionChip(
              label: Text(_format(filter)),
              onPressed: () => setState(() => this.url = filter),
            ),
          );
        },
      ),
    );
  }

  /// Remove extra string
  String _format(String url) {
    String temp = url.split('/').last.replaceFirst('-anime', '');
    final split = temp.split('-');
    return '${split[0]} ${split[1]}';
  }

  /// This returns pas 4 seasons
  List<String> _getSeasonList() {
    final List<String> seasons = [];
    DateTime _date = DateTime.now();

    // Add past 9 seasons including current season so past 8
    int offset = 0; // make it 0 to show current seacon
    for (int i = 0; i < 25; i++, offset -= 3) {
      // Keep updating the date, 31 days just in case
      var temp = this._getYearAndSeason(_date.add(Duration(days: offset * 30)));
      seasons.add('sub-category/${SEASONS[temp[1]]}-${temp[0]}-anime');
    }

    return seasons;
  }

  /// It returns year and season (0, 1, 2, 3)
  List<int> _getYearAndSeason(DateTime dt) {
    int year = dt.year;
    int month = dt.month;

    int season;
    if (month < 4)
      season = 0;
    else if (month < 7)
      season = 1;
    else if (month < 10)
      season = 2;
    else
      season = 3;

    return [year, season];
  }
}
