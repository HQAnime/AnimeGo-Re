import { Alert, Linking } from 'react-native';
import { VERSION } from '../value';

export default class GithubUpdate {
  constructor(url) {
    this.url = url;
  }

  checkUpdate(settings) {
    return new Promise((success, failure) => {
      fetch(this.url).then((html) => html.text()).then((htmlText) => {
        let HTMLParser = require('fast-html-parser');
        let root = HTMLParser.parse(htmlText);

        // When it does not work, check here
        let newVersion = root.querySelector('span.css-truncate-target');
        let download = root.querySelector('li.d-block.py-2');

        // When Github is down or Henry being stupid
        if (newVersion == null || download == null) return;
        // A new version
        let code = newVersion.text;
        if (code > VERSION) {
          let link = 'https://github.com/' + download.childNodes[1].attributes.href;
          console.log(code, link);
          Alert.alert('Update available', 'Do you want to download new apk?',
            [
              {text: 'SURE', onPress: () => Linking.openURL(link)},
            ],
          )
        } else if (settings) {
          Alert.alert('AnimeGo', 'Version ' + VERSION + ' is up to date');
        }
      })
      .catch((error) => {
        Alert.alert('Fatal', 'Error Unknown');        
        failure(error);
      });
    })
  }
}