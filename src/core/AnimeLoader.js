import { GoGoAnime } from '../Constant';

export default class AnimeLoader {

  constructor(url, page) {
    this.url = url;
    this.page = page;
  }

  loadAnime() {
    return new Promise((success, failure) => {
      // Loading data here
      // console.log(this.url + this.page);
      fetch(this.url + this.page)
      .then((html) => html.text())
      .then((htmlText) => {
        var HTMLParser = require('fast-html-parser');
        
        var root = HTMLParser.parse(htmlText).querySelector('.items');
        // Last page is reached
        if (root == null) return [];
        
        var items = root.childNodes;
        var animeData = [];
        var length = items.length;
        // This is only for new release
        if (length == 0) return [];
           
        for (var i = 0; i < length; i++) {
          var anime = items[i];
          // Somehow, next line is parsed as well
          if (anime.isWhitespace) continue;
          // console.log(anime);
          var animeImage = anime.querySelector('.img');
          var animeLink = GoGoAnime.MainURL + animeImage.childNodes[1].attributes.href;
          var animeName = anime.querySelector('.name').text;
          // Only for NewRelease, it is displaying episode.
          var extraInformation = this.url == GoGoAnime.NewRelease ? anime.querySelector('.episode').text : anime.querySelector('.released').removeWhitespace().text;
          var animeThumbnail = animeImage.childNodes[1].childNodes[1].attributes.src;
          animeData.push({name: animeName, episode: extraInformation, link: animeLink, thumbnail: animeThumbnail});
        }
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