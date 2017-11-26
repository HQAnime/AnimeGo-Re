import { Alert } from 'react-native';

export default class VideoLoader {

  constructor(url) {
    this.url = url;
  }

  getVideoUrl() {
    return new Promise((success, failure) => {
      // Loading data here
      // console.log(this.url);
      fetch(this.url)
      .then((html) => html.text())
      .then((htmlText) => {
        var HTMLParser = require('fast-html-parser');
        
        var root = HTMLParser.parse(htmlText);
        // console.log(root);
        var videoClass = root.querySelector('.video-js');
        // Somehow it does not exist
        if (videoClass == null) {
          Alert.alert('Error', 'No video');
          success('');
        }
        var link = videoClass.childNodes[1].attributes.src;

        // console.log(link);
        success(link);
      })
      .catch((error) => {
        // console.error(error);
        Alert.alert('Error', 'No video');        
        failure(error);
      });
    })
  }
}