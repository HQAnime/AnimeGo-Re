import React, { Component } from 'react';
import { View } from 'react-native';
import { SearchBar } from 'react-native-paper';
import { MajorLink, GoGoAnime, PRIMARY_COLOUR } from '../value';
import { AnimeList } from '../components/';

class NewRelease extends Component {
  state = { search: '' }

  render() {
    const { search } = this.state;
    return (
      <View style={{flex: 1}}>
        <View style={{elevation: 4, padding: 4, backgroundColor: PRIMARY_COLOUR}}>
          <SearchBar onIconPress={this.props.drawer()} onChangeText={input => this.input = input}
            onEndEditing={() => {
              if (this.input == null || this.input.length < 3) return;
              else {
                this.setState({search: this.input});
              }
            }} icon='menu' placeholder='Search AnimeGo'/>
        </View>
        {
          (search.length < 3) ? <AnimeList AnimeUrl={GoGoAnime + MajorLink.NewRelease}/>
          : <AnimeList AnimeUrl={GoGoAnime + MajorLink.Search + search + '&page='}/>
        }
      </View>
    )
  }
}

export { NewRelease };