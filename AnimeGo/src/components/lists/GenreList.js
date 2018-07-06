import React, { Component } from 'react';
import { View } from 'react-native';
import SuperGrid from 'react-native-super-grid';
import { GenreCell } from '../cells/GenreCell';

// All genres
const genreList = ['Action', 'Adventure', 'Cars', 'Comedy', 'Dementia', 'Demons', 'Drama', 'Ecchi', 'Fantasy', 
  'Game', 'Harem', 'Historical', 'Horror', 'Josei', 'Kids', 'Magic', 'Martial Arts', 'Mecha', 'Military', 
  'Music', 'Mystery', 'Parody', 'Police', 'Psychological', 'Romance', 'Samurai', 'School', 'Sci-Fi', 
  'Seinen', 'Shoujo', 'Shoujo Ai', 'Shounen', 'Shounen Ai', 'Slice of Life', 'Space', 'Sports', 'Super Power', 
  'Supernatural', 'Thriller', 'Vampire', 'Yaoi', 'Yuri'];

class GenreList extends Component {
  render() {
    return (
      <View style={{flex: 1}}>
        <SuperGrid renderItem={item => <GenreCell title={item}/>} 
          items={genreList} itemDimension={128}/>
      </View>
    )
  }
}

export { GenreList };