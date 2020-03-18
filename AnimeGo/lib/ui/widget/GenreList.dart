import 'package:AnimeGo/core/model/AnimeGenre.dart';
import 'package:AnimeGo/ui/page/GenrePage.dart';
import 'package:flutter/material.dart';

/// GenreList class
class GenreList extends StatelessWidget {
  /// The entire genre list all in one
  final genreList = ['Action', 'Adventure', 'Cars', 'Comedy', 'Dementia', 'Demons', 'Drama', 'Ecchi', 'Fantasy', 
                    'Game', 'Harem', 'Historical', 'Horror', 'Josei', 'Kids', 'Magic', 'Martial Arts', 'Mecha', 'Military', 
                    'Music', 'Mystery', 'Parody', 'Police', 'Psychological', 'Romance', 'Samurai', 'School', 'Sci-Fi', 
                    'Seinen', 'Shoujo', 'Shoujo Ai', 'Shounen', 'Shounen Ai', 'Slice of Life', 'Space', 'Sports', 'Super Power', 
                    'Supernatural', 'Thriller', 'Vampire', 'Yaoi', 'Yuri'];
  
  /// This is only used by TabletHomePage
  final Function func;
  GenreList({Key key, this.func}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      children: this.renderGenres(context),
    );
  }

  /// Render all genres as chips
  List<Widget> renderGenres(BuildContext context) {
    // Return a fixed length array (growable to be false)
    return this.genreList.map((item) => FlatButton(
        child: Text(item), 
        onPressed: () {
          if (func == null) {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => GenrePage(genre: AnimeGenre(item))));
          } else {
            func(item);
          }
        }, 
      ),
    ).toList(growable: false);
  }
}
