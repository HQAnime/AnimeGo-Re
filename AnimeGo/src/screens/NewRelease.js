import React, { Component } from 'react';
import { View } from 'react-native';
import { SearchBar } from 'react-native-paper';
import { MajorLink, GoGoAnime } from '../value';
import { AnimeList } from '../components/';

class NewRelease extends Component {
  render() {
    return (
      <View style={{flex: 1}}>
        <SearchBar style={{position: 'absolute', margin: 8, borderRadius: 8}} icon='menu' placeholder='Search AnimeGo'/>
        <AnimeList AnimeUrl={GoGoAnime + MajorLink.NewRelease} space/>
      </View>
    )
  }
}

export { NewRelease };