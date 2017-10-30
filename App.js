import React, { Component } from 'react';
import { SearchAnime } from './src/screen/SearchAnime';
import { RecentRelease } from './src/screen/RecentRelease';
import { Genre } from './src/screen/Genre';
import { NewSeason } from './src/screen/NewSeason';
import { View, Text, Button, Platform } from 'react-native';
import { StackNavigator } from 'react-navigation';
import { TabViewAnimated, TabBar, SceneMap } from 'react-native-tab-view';

class App extends Component {
  state = {
    index: 0,
    routes: [
      { key: '1', title: 'Recent' },
      { key: '2', title: 'Season' },
      { key: '3', title: 'Genre' },
    ],
  };

  _handleIndexChange = index => this.setState({ index });

  _renderHeader = props => <TabBar {...props} />;

  _renderScene = SceneMap({
    '1': RecentRelease,
    '2': NewSeason,
    '3': Genre,
  });

  render() {
    return (
      <TabViewAnimated
        navigationState={this.state}
        renderScene={this._renderScene}
        renderHeader={this._renderHeader}
        onIndexChange={this._handleIndexChange}
      />
    )
  }

  gotoSearch() {
    this.props.navigation.navigate('Search')
  }
}

const RootNavigator = StackNavigator({
  Home: {
    screen: App,
    navigationOptions: ({ navigation }) => ({
      headerTitle: 'GoGoAnime',
      headerRight: (
        <Button
          onPress={() => navigation.navigate('Search')}
          title="Search"
        />
      ),
      headerBackTitle: 'Back',
    }),
  },
  Search: {
    screen: SearchAnime,
    navigationOptions: {
      headerTitle: 'Seach Anime',
    },
  }
});

export default RootNavigator;