import { MajorLink } from '../value';
import { Alert } from 'react-native';

export default class AnimeSchedule {
  getScheduleForToday() {
    return new Promise((success, failure) => {
      // Loading data here
      let weekdays = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
      fetch(MajorLink.Schedule).then((html) => html.text()).then((htmlText) => {
        var HTMLParser = require('fast-html-parser');
        let weekdayClass = '.js-seasonal-anime-list-key-' + weekdays[new Date().getDay()];
        var root = HTMLParser.parse(htmlText).querySelector(weekdayClass);
        // Somehow, nothing is found
        if (root == null) success([]);

        var animeSchedule = [];
        for (var i = 0; i < root.childNodes.length; i++) {
          var curr = root.childNodes[i];
          // Ignore whitespaces and header
          if (curr.isWhitespace || curr.classNames[0] == 'anime-header') continue;
          curr = curr.childNodes;
          console.log(curr);
          let name = this.cleanText(curr[2].text);
          var link = ''; let linkPath = curr[0].childNodes[1].childNodes;
          if (linkPath[1].isWhitespace) link = linkPath[0].childNodes[1].attributes.href;
          else link = linkPath[1].childNodes[1].attributes.href;
          let image = curr[2].childNodes[0].attributes["data-src"];
          let time = this.cleanText(curr[6].childNodes[1].text).split(' -')[1];
          let rating = '⭐️' + this.cleanText(curr[6].childNodes[3].childNodes[3].text);
          animeSchedule.push({name: name, link: link, time: time, image: image, rating: rating});
        }
         console.log(animeSchedule);
        success(animeSchedule);
      }).catch((error) => {
        // console.error(error);
        Alert.alert('Error', 'Schedule not found');
        failure(error);
      });
    })
  }

  cleanText(input) {
    var noNextLine = input.split('\n').join(' ');
    return noNextLine.split('  ').join('');
  }
}