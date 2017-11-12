import { GoGoAnime } from '../Constant';

export default class EpisodeLoader {
  
    constructor(ep_start, ep_end, id, lastest) {
      this.start = ep_start;
      this.end = ep_end;
      this.id = id;
      this.lastest = lastest;
    }
  
    loadEpisode() {
      return new Promise((success, failure) => {
        // Loading data here
        var url = GoGoAnime.Episode + this.start + '&ep_end=' + this.end + '&id=' + this.id;
        // console.log(url);
        fetch(url)
        .then((html) => html.text())
        .then((htmlText) => {
          var HTMLParser = require('fast-html-parser');
          
          var root = HTMLParser.parse(htmlText);
          var animeEpisodes = root.querySelector('#episode_related');
          // Somehow it is empty
          if (animeEpisodes == null) return [{link: 'Error', number: '??'}];

          animeEpisodes = animeEpisodes.childNodes;
          var length = animeEpisodes.length;
          // Somehow it does not have any episodes
          if (length == 0) return [{link: 'Error', number: '??'}];

          var animeData = [];

          for (var i = 0; i < length; i++) {
            var episode = animeEpisodes[i];
            // Just in case but ther should not be any empty entries
            if (episode.isWhitespace) continue;
            // It has an empty space for some reason...
            var animeLink = GoGoAnime.MainURL + episode.childNodes["0"].attributes.href.replace(' ', '');
            var episodeNumber = episode.childNodes["0"].childNodes[1].text.replace(' EP', '');

            animeData.push({link: animeLink, number: episodeNumber});

            if (this.start == 0 && i == length - 1) {
              // Add latest episode in front of this one
              var lastestLink = animeLink.split('-').slice(0, -1).join('-') + '-' +this.lastest;
              animeData.push({link: lastestLink, number: this.lastest});
            }
          }

          // By default, it is starting from ep_end. Only need to reverse this.
          animeData = animeData.reverse();
          // console.log(animeData);
          success(animeData);
        })
        .catch((error) => {
          // console.error(error);
          failure(error);
        });
      })
    }
  }