import { GoGoAnime } from '../Constant';
 
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
        if (animeSources == null) success({});
        var info = animeSources.childNodes;
        // console.log(info);

        var animeName = info[3].rawText;
        var animeImage = info[1].attributes.src;
        var animeType = info[7].childNodes[2].attributes.title;
        var animeTypeLink = GoGoAnime.MainURL + info[7].childNodes[2].attributes.href;
        var animePlot = info[9].childNodes[1].rawText;
        var animeGenre = info[11].structuredText.replace('Genre: ', '');
        var animeRelease = info[13].childNodes[1].rawText;
        var animeStatus = info[15].childNodes[1].rawText;

        var animeInfo = {name: animeName, image: animeImage, type: animeType, typeLink: animeTypeLink, plot: animePlot, 
          genre: animeGenre, release: animeRelease, status: animeStatus};
        
        // console.log(animeInfo);
        success(animeInfo);
      })
      .catch((error) => {
        // console.error(error);
        failure(error);
      });
    })
  }
}