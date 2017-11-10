import React, { Component } from 'react';
import { FlatList, View, Dimensions } from 'react-native';
import GenreCell from './GenreCell';

// All availabel genre
const genreList = ['Action', 'Adventure', 'Cars', 'Comedy', 'Dementia', 'Demons', 'Drama', 'Ecchi', 'Fantasy', 
'Game', 'Harem', 'Historical', 'Horror', 'Josei', 'Kids', 'Magic', 'Martial Arts', 'Mecha', 'Military', 
'Music', 'Mystery', 'Parody', 'Police', 'Psychological', 'Romance', 'Samurai', 'School', 'Sci-Fi', 
'Seinen', 'Shoujo', 'Shoujo Ai', 'Shounen', 'Shounen Ai', 'Slice of Life', 'Space', 'Sports', 'Super Power', 
'Supernatural', 'Thriller', 'Vampire', 'Yaoi', 'Yuri'];/*[{name: 'Action'}, {name: 'Adventure'}, {name: 'Cars'}, {name: 'Comedy'}, {name: 'Dementia'}, {name: 'Demons'}, {name: 'Drama'}, {name: 'Ecchi'}, {name: 'Fantasy'}, 
{name: 'Game'}, {name: 'Harem'}, {name: 'Historical'}, {name: 'Horror'}, {name: 'Josei'}, {name: 'Kids'}, {name: 'Magic'}, {name: 'Martial Arts'}, {name: 'Mecha'}, {name: 'Military'}, 
{name: 'Music'}, {name: 'Mystery'}, {name: 'Parody'}, {name: 'Police'}, {name: 'Psychological'}, {name: 'Romance'}, {name: 'Samurai'}, {name: 'School'}, {name: 'Sci-Fi'}, 
{name: 'Seinen'}, {name: 'Shoujo'}, {name: 'Shoujo Ai'}, {name: 'Shounen'}, {name: 'Shounen Ai'}, {name: 'Slice of Life'}, {name: 'Space'}, {name: 'Sports'}, {name: 'Super Power'}, 
{name: 'Supernatural'}, {name: 'Thriller'}, {name: 'Vampire'}, {name: 'Yaoi'}, {name: 'Yuri'}];*/

const isPortrait = () => {
  const dim = Dimensions.get('screen');
  return dim.height >= dim.width;
};

class GenreList extends Component {

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
          renderItem={(genre) => 
            <GenreCell data={genre.item}/>
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