import React, { Component } from 'react';
import { FlatList, View } from 'react-native';
import { isPortrait } from '../../helper/DeviceDimensions';
import GenreCell from '../cell/GenreCell';

// All genres
const genreList = ['Action', 'Adventure', 'Cars', 'Comedy', 'Dementia', 'Demons', 'Drama', 'Ecchi', 'Fantasy', 
'Game', 'Harem', 'Historical', 'Horror', 'Josei', 'Kids', 'Magic', 'Martial Arts', 'Mecha', 'Military', 
'Music', 'Mystery', 'Parody', 'Police', 'Psychological', 'Romance', 'Samurai', 'School', 'Sci-Fi', 
'Seinen', 'Shoujo', 'Shoujo Ai', 'Shounen', 'Shounen Ai', 'Slice of Life', 'Space', 'Sports', 'Super Power', 
'Supernatural', 'Thriller', 'Vampire', 'Yaoi', 'Yuri'];

class GenreList extends React.PureComponent {
  componentWillMount() {
    this.updateColumn();
  }

  render() {
    const { column } = this.state;
    return (
      <View style={{flex: 1}} onLayout={this.updateColumn}>
        <FlatList data={genreList} keyExtractor={(genre) => genre} key={isPortrait ? 'p' + column : 'h' + column}
          renderItem={({item}) => <GenreCell data={item} column={column}/> } numColumns={column}/>
      </View>
    )
  }

  updateColumn = () => this.setState({column: isPortrait() ? 3 : 6});
}

export {GenreList};