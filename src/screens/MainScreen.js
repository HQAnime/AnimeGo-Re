import React, { Component } from 'react';
import { Dimensions } from 'react-native';
import { TabViewAnimated, TabBar, SceneMap } from 'react-native-tab-view';
import { NewSeason, Genre, RecentRelease, Movie, Popular } from './';
import { MainScreenStyles } from '../Styles';

class MainScreen extends Component {

  state = {
    index: 0,
    routes: [
      { key: '1', title: 'Lastest' },
      { key: '2', title: 'New Season' },
      { key: '3', title: 'Movie' },
      { key: '4', title: 'Popular'},
      { key: '5', title: 'Genre'},
    ],
  };

  handleIndexChange = index => this.setState({ index });
  
  renderHeader = props => {
    return (
      <TabBar
        {...props}
        scrollEnabled useNativeDriver
        tabStyle = { tabStyle }
        indicatorStyle = { indicatorStyle } 
        style = { tabBarStyle }/>
    );
  };

  renderScene = SceneMap({
    '1': RecentRelease,
    '2': NewSeason,
    '3': Movie,
    '4': Popular,
    '5': Genre,
  });

  render() {
    return (
      <TabViewAnimated initialLayout={{width: Dimensions.get('window').width, height: 0}}
        navigationState={this.state}
        renderScene={this.renderScene}
        renderHeader={this.renderHeader}
        onIndexChange={this.handleIndexChange}
      />
    );
  }
}

// From styles.js
const { tabBarStyle, indicatorStyle, tabStyle } = MainScreenStyles;

export { MainScreen };