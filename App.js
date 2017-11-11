import React, { Component } from 'react';
import { MainScreen, AnimeDetail, SearchAnime, 
  WatchAnime, NewSeason, Genre, RecentRelease, Movie, GenreDetail } from './src/screens/';
import { Button } from 'react-native-elements';
import { Router, Scene, Actions } from 'react-native-router-flux';
import { Platform } from 'react-native';

class App extends Component {
  render() {
    return (
      <Router sceneStyle={{backgroundColor: 'white'}}>
        <Scene key='root' headerTintColor='white'>
          <Scene key='MainScreen' component={ MainScreen } title='GoGoAnime' initial
            titleStyle={styles.titleStyle} navigationBarStyle={styles.mainNavBarStyle}
            renderRightButton={(
              <Button
                icon={{name: 'search', type: 'evil-icons', size: (Platform.OS === 'ios') ? 22 : 30}}
                buttonStyle={{backgroundColor: 'transparent'}} onPress={() => Actions.SearchScreen()}
              />
            )} backTitle='Back' initial/>
          <Scene key='SearchScreen' component={ SearchAnime } title='Search'
            titleStyle={styles.titleStyle} navigationBarStyle={styles.searchNavBarStyle}/>
          <Scene key='GenreDetail' component={ GenreDetail } title='GenreDetail' 
            titleStyle={styles.titleStyle} navigationBarStyle={styles.searchNavBarStyle}/>
          <Scene key='WatchAnime' component={ WatchAnime } title='WatchAnime'
            titleStyle={styles.titleStyle} navigationBarStyle={styles.searchNavBarStyle}/>
          <Scene key='AnimeDetail' component={ AnimeDetail } title='AnimeDetail'
            titleStyle={styles.titleStyle} navigationBarStyle={styles.searchNavBarStyle}/>
        </Scene>
      </Router>
    );
  }
}

const styles = {
  titleStyle: {
    width: '90%',
  },
  mainNavBarStyle: {
    backgroundColor: '#1b1b1b',
    justifyContent: 'center',
    elevation: 0,
  },
  searchNavBarStyle: {
    backgroundColor: '#1b1b1b',
  }
}

export default App;