import { Alert } from 'react-native';
import { MajorLink } from '../../value';

export default class AnimeSourceLoader {

  constructor(url) {
    this.url = url;
  }

  loadSource() {
    return new Promise((success, failure) => {
      // Loading data here
      // console.log(this.url);
      fetch(this.url)
      .then((html) => html.text())
      .then((htmlText) => {
        var HTMLParser = require('fast-html-parser');
        var prev = ''; var next = '';        
        
        var root = HTMLParser.parse(htmlText);
        var animeSources = root.querySelector('.anime_muti_link');
        // Somwhow it does not exist
        if (animeSources == null) success([[], prev, next]);

        var items = animeSources.childNodes[1].childNodes;
        var animeData = [];
        var length = items.length;
        
        // Somwhow it does not have any sources
        if (length == 0) success([[], prev, next]);
        
        // Getting anime information
        animeInfoLink = '';
        animeName = '';
        var animeInfo = root.querySelector('.anime-info');      
        if (animeInfo != null) {
          // Getting info link
          animeInfoLink = global.domain + animeInfo.childNodes[3].attributes.href;
          animeName = animeInfo.childNodes[3].attributes.title;
          // console.log(animeInfoLink, animeName);
        }

        // Get download link (no longer available)
        animeData.push({source: '', name: 'Download'});
        
        for (var i = 0; i < length; i++) {
          var source = items[i];
          // Somehow, next line is parsed as well
          if (source.isWhitespace) continue;
          // console.log(source);
          var animeSource = source.childNodes[1].attributes["data-video"];
          var sourceName = source.removeWhitespace().rawText.replace('Choose this server', '');
          // The first source does not include https:
          if (!animeSource.includes('http')) animeSource = 'https:' + animeSource;
          animeData.push({source: animeSource, name: sourceName, animeName: animeName, infoLink: animeInfoLink});
        }
        // console.log(animeData);

        // Getting next and prev info
        var nextPrev = root.querySelector('.anime_video_body_episodes'); 
        if (nextPrev != null) {
          console.log(nextPrev);
          prev = nextPrev.childNodes[1].childNodes[1];
          next = nextPrev.childNodes[3].childNodes[1];
          if (prev != null) prev = global.domain + prev.attributes.href;
          if (next != null) next = global.domain + next.attributes.href;
        }

        success([animeData, prev, next]);
      })
      .catch((error) => {
        // console.error(error);
        Alert.alert('Error', 'Source not found');
        failure(error);
      });
    })
  }
}