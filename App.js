import React, { Component } from 'react';
import { MainScreen, AnimeDetail, SearchAnime, 
  WatchAnime, GenreDetail } from './src/screens/';
import { Button } from 'react-native-elements';
import { NavigationStyles } from './src/Styles';
import { Router, Scene, Actions } from 'react-native-router-flux';
import { Platform, Linking } from 'react-native';

class App extends Component {
  render() {
    return (
      <Router sceneStyle={{backgroundColor: 'white'}}>
        <Scene key='root' headerTintColor='white'>
          <Scene key='MainScreen' component={ MainScreen } title='GoGoAnime' initial
            titleStyle={titleStyle} navigationBarStyle={mainNavBarStyle}
            renderRightButton={(
              <Button
                icon={{name: 'search', type: 'evil-icons', size: (Platform.OS === 'ios') ? 22 : 30}}
                buttonStyle={{backgroundColor: 'transparent'}} onPress={() => Actions.SearchScreen()}
              />
            )} renderLeftButton={(
              <Button
                icon={{name: 'logo-github',type: 'ionicon', size: (Platform.OS === 'ios') ? 22 : 30}}
                buttonStyle={{backgroundColor: 'transparent'}} onPress={() => {
                  if (Platform.OS == 'ios') {
                    var Browser = require('react-native-browser');
                    Browser.open('https://github.com/HenryQuan/React-Native-GoGoAnime');
                  } else {
                    Linking.openURL('https://github.com/HenryQuan/React-Native-GoGoAnime').catch(err => console.error('An error occurred', err));                    
                  }
                }}
              />
            )} backTitle='Back' initial/>
          <Scene key='SearchScreen' component={ SearchAnime } title='Search'
            titleStyle={titleStyle} navigationBarStyle={searchNavBarStyle}/>
          <Scene key='GenreDetail' component={ GenreDetail } title='GenreDetail' 
            titleStyle={titleStyle} navigationBarStyle={searchNavBarStyle}/>
          <Scene key='WatchAnime' component={ WatchAnime } title='WatchAnime'
            titleStyle={titleStyle} navigationBarStyle={searchNavBarStyle}/>
          <Scene key='AnimeDetail' component={ AnimeDetail } title='AnimeDetail'
            titleStyle={titleStyle} navigationBarStyle={searchNavBarStyle}/>
        </Scene>
      </Router>
    );
  }
}

const { titleStyle, mainNavBarStyle, searchNavBarStyle } = NavigationStyles;

export default App;