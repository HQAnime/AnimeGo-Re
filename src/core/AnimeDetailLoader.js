import { GoGoAnime } from '../Constant';
import { Alert } from 'react-native';
 
export default class AnimeDetailLoader {

  constructor(url) {
    this.url = url;
  }

  loadInformation() {
    return new Promise((success, failure) => {
      // Loading data here
      // console.log(this.url);
      fetch(this.url)
      .then((html) => html.text())
      .then((htmlText) => {
        var HTMLParser = require('fast-html-parser');
        
        var root = HTMLParser.parse(htmlText);
        var animeSources = root.querySelector('.anime_info_body_bg');
        // Somwhow it does not exist
        if (animeSources == null) {
          Alert.alert('Error', 'Info could not be loaded');
          success({});
        }
        var info = animeSources.childNodes;
        // console.log(info);

        var animeName = info[3].rawText;
        var animeImage = info[1].attributes.src;
        var animeType = info[7].childNodes[2].attributes.title;
        var animeTypeLink = GoGoAnime.MainURL + info[7].childNodes[2].attributes.href;
        var plot = 'No Information';
        var animePlot = info[9].childNodes[1];
        if (animePlot != null) plot = animePlot.rawText;
        var animeGenre = info[11].structuredText.replace('Genre: ', '');
        var animeRelease = info[13].childNodes[1].rawText;
        var animeStatus = info[15].childNodes[1].rawText;

        // Get episodes
        var animeEpisode = '0';
        var episodes = root.querySelector('#episode_page');
        // console.log(episodes);
        if (episodes != null) {
          var episode = episodes.childNodes;
          var animeEpisode = episode[episode.length - 2].childNodes[1].rawAttrs.split(' ep_end = ')[1];
          animeEpisode = animeEpisode.split("'").join('');
          // console.log(animeEpisode);
        } else {
          Alert.alert('Warning', 'No episodes');
        }

        // Getting movie_id
        var animeId = '';
        var movieId = root.querySelector('.movie_id');
        if (movieId != null) animeId = movieId.attributes.value;
        // console.log(animeId);

        var animeInfo = {name: animeName, image: animeImage, type: animeType, typeLink: animeTypeLink, plot: plot, 
          genre: animeGenre, release: animeRelease, status: animeStatus, episode: animeEpisode, id: animeId};
        
        // console.log(animeInfo);
        success(animeInfo);
      })
      .catch((error) => {
        // console.error(error);
        Alert.alert('Error', 'Info could not be loaded');
        failure(error);
      });
    })
  }
}