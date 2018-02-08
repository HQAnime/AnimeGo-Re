import React, { Component } from 'react';
import { View, Dimensions, Text } from 'react-native';
import { Button } from 'react-native-elements';
import { Colour, WindowsButtonStyles } from '../Styles';
import { Actions } from 'react-native-router-flux';

class GenreCell extends React.PureComponent {
  render() {
    return (
      <View style={{flex: 0.5, margin: 0, padding: 4}}>
        <Button title={this.props.data} backgroundColor={Colour.GoGoAnimeOrange}
          buttonStyle={WindowsButtonStyles.buttonStyle} onPress={this.GenreDetail} />
      </View>
    )
  }

  GenreDetail = () => {
    const title = this.props.data;
    // replace only works for first match
    const genre = title.split(' ').join('-') + '?page=';
    // console.log(title, genre);
    Actions.GenreDetail({title: title, genre: genre});
  }
}

export default GenreCell;