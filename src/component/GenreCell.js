import React, { Component } from 'react';
import { View, Button, Dimensions } from 'react-native';
import { Colour } from '../Styles';
import { GoGoAnime } from '../Constant';
import { Actions } from 'react-native-router-flux';

const { width } = Dimensions.get('window');

class GenreCell extends Component {
  render() {
    return (
      <View style={{width: width / 2}}>
        <Button title={this.props.data} color={Colour.GoGoAnimeOrange} onPress={this.GenreDetail}/>
      </View>
    )
  }

  GenreDetail = () => {
    const title = this.props.data;
    const genre = title.replace(' ', '-') + '?page=';
    console.log(title, genre);
    Actions.GenreDetail({title: title, genre: genre});
  }
}

export default GenreCell;