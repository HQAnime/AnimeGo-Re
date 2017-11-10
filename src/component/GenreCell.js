import React, { Component } from 'react';
import { View, Button, Dimensions, Text } from 'react-native';
import { Colour } from '../Styles';
import { Actions } from 'react-native-router-flux';

const { width } = Dimensions.get('window');

class GenreCell extends Component {
  render() {
    return (
      <View style={{flex: 1, width: width / 2, margin: 2, padding: 4}}>
        <Button title={this.props.data} color={Colour.GoGoAnimeOrange} onPress={this.GenreDetail} />
      </View>
    )
  }

  GenreDetail = () => {
    const title = this.props.data;
    const genre = title.replace(' ', '-') + '?page=';
    // console.log(title, genre);
    Actions.GenreDetail({title: title, genre: genre});
  }
}

export default GenreCell;