import React, { Component } from 'react';
import { FlatList, View, Dimensions } from 'react-native';
import GenreCell from './GenreCell';

// All availabel genre
const genreList = ['Action', 'Adventure', 'Cars', 'Comedy', 'Dementia', 'Demons', 'Drama', 'Ecchi', 'Fantasy', 
'Game', 'Harem', 'Historical', 'Horror', 'Josei', 'Kids', 'Magic', 'Martial Arts', 'Mecha', 'Military', 
'Music', 'Mystery', 'Parody', 'Police', 'Psychological', 'Romance', 'Samurai', 'School', 'Sci-Fi', 
'Seinen', 'Shoujo', 'Shoujo Ai', 'Shounen', 'Shounen Ai', 'Slice of Life', 'Space', 'Sports', 'Super Power', 
'Supernatural', 'Thriller', 'Vampire', 'Yaoi', 'Yuri'];

const isPortrait = () => {
  const dim = Dimensions.get('screen');
  return dim.height >= dim.width;
};

class GenreList extends React.PureComponent {

  constructor(props) {
    super(props);
    this.state = {
      orientation: isPortrait() ? 'portrait' : 'landscape',
    };
  }

  render() {
    return (
      <View style={{flex: 1}} onLayout={this.updateView}>
        <FlatList data={genreList} keyExtractor={(genre) => genre}
          renderItem={({item}) => 
            <GenreCell data={item}/>
          } numColumns={2}/>
      </View>
    )
  }

  updateView = () => {
    var currOrientation = isPortrait() ? 'portrait' : 'landscape';
    if (this.state.orientation == currOrientation) return;
    this.setState({
      orientation: currOrientation,
    })
  }

}



export {GenreList};