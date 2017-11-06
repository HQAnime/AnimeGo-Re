import React, { Component } from 'react';
import { MainScreen, AnimeDetail, SearchAnime, 
  WatchAnime, NewSeason, Genre, RecentRelease, Movie } from './src/screens/';
import { View, Text } from 'react-native';
import { Router, Scene } from 'react-native-router-flux';

class App extends Component {
  render() {
    return (
      <Router>
        <Scene key="root">
          <Scene key="MainScreen" component={ MainScreen } title="GoGoAnime" 
            titleStyle={styles.titleStyle} navigationBarStyle={styles.navBarStyle}/>
          <Scene key="SearchScreen" component={ SearchAnime } title="Search Anime"/>
        </Scene>
      </Router>
    );
  }
}

const styles = {
  titleStyle: {
    color: '#FFF',
    width: '85%',
  },
  navBarStyle: {
    backgroundColor: '#1b1b1b',
    elevation: 0,
  }
}

export default App;