import React, { Component } from 'react';
import { TabViewAnimated, TabBar, SceneMap } from 'react-native-tab-view';
import { AnimeDetail, SearchAnime, 
  WatchAnime, NewSeason, Genre, RecentRelease, Movie } from './';

class MainScreen extends Component {
  state = {
    index: 0,
    routes: [
      { key: '1', title: 'New Release' },
      { key: '2', title: 'New Season' },
      { key: '3', title: 'Movie' },
      { key: '4', title: 'Genre'},
    ],
  };

  _handleIndexChange = index => this.setState({ index });
  
  _renderHeader = props => {
    return (
      <TabBar
        {...props}
        scrollEnabled 
        tabStyle = { styles.tabBarStyle }
        indicatorStyle = { styles.indicatorStyle } 
        style = { styles.tabStyle }/>
    );
  };

  _renderScene = SceneMap({
    '1': RecentRelease,
    '2': NewSeason,
    '3': Movie,
    '4': Genre,
  });

  render() {
    return (
      <TabViewAnimated
        navigationState={this.state}
        renderScene={this._renderScene}
        renderHeader={this._renderHeader}
        onIndexChange={this._handleIndexChange}
      />
    );
  }
}

const styles = {
  tabStyle: {
    backgroundColor: '#f5c249',
  },
  tabBarStyle: {
    height: 40,
    backgroundColor: 'transparent',
  },
  indicatorStyle: {
    backgroundColor: 'white',
  },
}

export { MainScreen };