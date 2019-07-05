import React, { PureComponent } from 'react';
import { View, Text } from 'react-native';
import { SmartTouchable } from '../../component';
import { styles } from './GenreCellStyles';
import { SecondaryColour } from '../../value';
import { Actions } from 'react-native-router-flux';
import { Button } from 'react-native-paper';

class GenreCell extends PureComponent {
  constructor(props) {
    super();
    this.flex = 1 / props.column;
    this.title = props.data;
  }

  render() {
    const { viewStyle, textStyle } = styles;  
    return (
      <View style={{flex: this.flex}}>
        <Button onPress={this.showGenreInfo}>{this.title}</Button>
      </View>
    )
  }

  showGenreInfo = () => {
    let genre = this.title.split(' ').join('-') + '?page=';
    // console.log(title, genre);
    Actions.GenreInfo({title: this.title, genre: genre, headerTintColor: 'white'});
  }
}

export default GenreCell;