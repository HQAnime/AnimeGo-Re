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
        var videoClass = root.querySelector('.video-js');
         console.log(videoClass);
        // Somehow it does not exist
        if (videoClass == null) {
          Alert.alert('Error', 'No video');
          success('');
        }

        let videos = videoClass.childNodes;
        var link = '';
        for (var i = 0; i < videos.length; i++) {
          var video = videos[i];
          // Somehow, next line is parsed as well
          if (video.isWhitespace) continue;
          // console.log(video);
          // Choose the best quality
          if (video.attributes.label == "auto") {
            link = video.attributes.src;
          }
        }

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