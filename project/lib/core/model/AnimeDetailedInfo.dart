import 'package:animego/core/model/AnimeGenre.dart';
import 'package:animego/core/model/EpisodeSection.dart';
import 'package:html/dom.dart';
import 'package:logging/logging.dart';

/// This contains the detailed anime info including descriptions
class AnimeDetailedInfo {
  String? image;
  String? name;
  String? category;
  String? categoryLink;
  String? summary;
  List<AnimeGenre> genre = [];
  String? released;
  String? status;

  final _logger = Logger('AnimeDetailedInfo');

  /// A list of episode (1 - 100, 101 - 200 and so on)
  List<EpisodeSection> episodes = [];
  String? lastEpisode;

  AnimeDetailedInfo(Document? body) {
    // Parse basic info
    final classes = body?.getElementsByClassName('anime_info_body_bg') ?? [];
    if (classes.isNotEmpty) {
      final infoClass = classes[0];
      image = infoClass.nodes[1].attributes['src'];
      name = infoClass.nodes[3].text;

      final categoryNode = infoClass.nodes[7].nodes[2];
      category = categoryNode.attributes['title']?.replaceAll('Anime', '');
      categoryLink = categoryNode.attributes['href'];

      // Remove the title
      try {
        // Can be empty
        summary = infoClass.nodes[9].nodes[1].text?.trimRight();
      } catch (e, s) {
        _logger.severe(e);
        _logger.severe(s);
        summary = 'No summary';
      }
      final genreNode = infoClass.nodes[13].nodes;
      // Remove the first node, it is just genre
      genreNode.removeAt(0);
      for (final element in genreNode) {
        if (element is Element) {
          // Only the first item doesn't have a comma
          genre.add(AnimeGenre(element.text.split(',').last.trim()));
        }
      }

      released = infoClass.nodes[15].nodes[1].text;
      status = infoClass.nodes[17].nodes[1].text;

      // Parse current anime movie id
      final movieClass = body?.getElementById('movie_id');
      // This is necessary for episode section to return the link
      final animeID = movieClass?.attributes['value'];

      final episodeClass = body?.getElementById('episode_page');
      for (final element in episodeClass?.nodes ?? []) {
        if (element is Element) {
          episodes.add(EpisodeSection(element, animeID));
        }
      }

      // Make sure it is not empty at least
      if (episodes.isNotEmpty) lastEpisode = episodes.last.episodeEnd;
    }
  }
}
