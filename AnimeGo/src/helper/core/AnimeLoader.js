import { MajorLink } from '../../value';
import { Alert } from 'react-native';

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
        if (root == null) success([]);

        var items = root.childNodes;
        // For search when no reult has been found
        if (items["0"].rawText.includes('Sorry')) {
          success([{name: 'Anime not found\n>_<', info: 'Back', link: 'Error', thumbnail: 'https://ww4.gogoanime.io/img/icon/logo.png'}]);
        }

        var animeData = [];
        var length = items.length;
        // This is only for new release
        if (length == 0) success([]);

        // console.log(length, items);
        for (var i = 0; i < length; i++) {
          var anime = items[i];
          // Somehow, next line is parsed as well
          if (anime.isWhitespace) continue;
          // console.log(anime);
          var animeImage = anime.querySelector('.img');
          var animeLink = MajorLink.MainURL + animeImage.childNodes[1].attributes.href;
          var animeName = anime.querySelector('.name').text;
          // Only for NewRelease, it is displaying episode.
          var extraInformation = this.url == MajorLink.NewRelease ? anime.querySelector('.episode').text : anime.querySelector('.released').removeWhitespace().text;
          if (extraInformation == '') extraInformation = '??';
          var animeThumbnail = animeImage.childNodes[1].childNodes[1].attributes.src;
          animeData.push({name: animeName, info: extraInformation, link: animeLink, thumbnail: animeThumbnail});
        }
        // console.log(animeData);
        success(animeData);
      })
      .catch((error) => {
        // console.error(error);
        Alert.alert('Error', 'Anime not found');
        failure(error);
      });
    })
  }
}