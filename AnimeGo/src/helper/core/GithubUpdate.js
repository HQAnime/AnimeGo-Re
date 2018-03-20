import { Alert } from 'react-native';
import { VERSION } from '../../value';

export default class GithubUpdate {

  constructor(url) {
    this.url = url;
  }

  checkUpdate() {
    return new Promise((success, failure) => {
      fetch(this.url).then((html) => html.text()).then((htmlText) => {
        let HTMLParser = require('fast-html-parser');
        let root = HTMLParser.parse(htmlText);
        let newVersion = root.querySelector('.css-truncate-target');
        let download = root.querySelector('.my-4');
        // When Github is down or Henry being stupid
        if (newVersion == null || download == null) Alert.alert('Fatal Error', 'APK not found');
        // A new version
        let code = newVersion.text;
        if (code > VERSION) {
          let link = 'https://github.com/' + download.childNodes[3].childNodes[1].childNodes[1].attributes.href;
          Alert.alert('Update available', 'Do you want to download new apk?',
            [
              {text: 'Cancel', onPress: () => console.log('User cancelled update'), style: 'cancel'},
              {text: 'OK', onPress: () => Linking.openURL(link)},
            ],
          )
        } else if (code < VERSION){
          Alert.alert('はわわです', 'How could you get version ' + VERSION + '\nHave you hacked the version number?');
        } else{
          Alert.alert(code, 'AnimeGo is up to date');
        }
      })
      .catch((error) => {
        Alert.alert('Fatal', 'Error Unknown');        
        failure(error);
      });
    })
  }
}