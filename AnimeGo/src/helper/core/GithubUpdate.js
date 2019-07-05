import { Alert, Linking } from 'react-native';
import { VERSION, LastestRelease } from '../../value';

export default class GithubUpdate {

  constructor(url) {
    this.url = url;
  }

  checkUpdate() {
    return new Promise((success, failure) => {
      fetch(this.url).then((html) => html.json()).then((json) => {
        let code = json['version'];
        if (code > VERSION) {
          Alert.alert('Update available', 'Do you want to download new apk?',
            [
              {text: 'Cancel', onPress: () => console.log('User cancelled update'), style: 'cancel'},
              {text: 'OK', onPress: () => Linking.openURL(LastestRelease)},
            ],
          )
        } else{
          Alert.alert(code, 'AnimeGo is up to date');
        }
        success();
      })
      .catch((error) => {
        Alert.alert('Fatal', 'Error Unknown');        
        failure(error);
      });
    })
  }
}