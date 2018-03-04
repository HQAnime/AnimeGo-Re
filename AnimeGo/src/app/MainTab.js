/*
  App.js
  Created on 19 Feb 2018 
  by Yiheng Quan
*/

import React, { PureComponent } from 'react';
import { TabBarIOS, View } from 'react-native';
import { NewRelease, NewSeason, SearchAnime, Popular, Genre } from '../screen';
import { AnimeGoColour } from '../value';

class MainTab extends PureComponent {
  state = {
    selected: 'NewRelease'
  }

  render() {
    const { selected } = this.state;
    return (
      <TabBarIOS tintColor={AnimeGoColour}>
        <TabBarIOS.Item title='New Release' selected={selected === 'NewRelease'}
           onPress={() => this.setTab('NewRelease')}>
          <NewRelease />
        </TabBarIOS.Item>
        <TabBarIOS.Item title='New Season' selected={selected === 'NewSeason'}
           onPress={() => this.setTab('NewSeason')}>
          <NewSeason />
        </TabBarIOS.Item>
        <TabBarIOS.Item title='Search' selected={selected === 'Search'}
           onPress={() => this.setTab('Search')}>
          <SearchAnime />
        </TabBarIOS.Item>
        <TabBarIOS.Item title='Popular' selected={selected === 'Popular'}
           onPress={() => this.setTab('Popular')}>
          <Popular />
        </TabBarIOS.Item>
        <TabBarIOS.Item title='Genre' selected={selected === 'Genre'}
           onPress={() => this.setTab('Genre')}>
          <Genre />
        </TabBarIOS.Item>
      </TabBarIOS>
    )
  }

  setTab(ID) {
    this.setState({selected: ID});
  }
}

export default MainTab;