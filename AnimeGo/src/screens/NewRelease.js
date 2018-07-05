import React, { Component } from 'react';
import { View } from 'react-native';
import { SearchBar } from 'react-native-paper';
import { MajorLink, GoGoAnime, PRIMARY_COLOR } from '../value';
import { AnimeList } from '../components/';

class NewRelease extends Component {
  render() {
    console.log(this.props)
    return (
      <View style={{flex: 1}}>
        <AnimeList AnimeUrl={GoGoAnime + MajorLink.NewRelease} space/>
        <View style={{elevation: 4, opacity: 0.9, padding: 4, top: 0, position: 'absolute', backgroundColor: '#FF9800', width: '100%'}}>
          <SearchBar onIconPress={this.props.drawer()} style={{flex: 1}}
          icon='menu' placeholder='Search AnimeGo'/>
        </View>
      </View>
    )
  }
}

export { NewRelease };