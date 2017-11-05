import React, { Component } from 'react';
import { MainScreen, AnimeDetail, SearchAnime, 
  WatchAnime, NewSeason, Genre, RecentRelease } from './src/screens/';
import { View, Text } from 'react-native';

class App extends Component {
  render() {
    return (
      <View style={styles.Container}>
        <Text>GoGoAnime</Text>
      </View>
    );
  }
}

const styles = {
  Container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center'
  },
}

export default App;