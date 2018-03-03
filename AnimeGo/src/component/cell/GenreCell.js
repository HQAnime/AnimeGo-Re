import React, { PureComponent } from 'react';
import { View, Button, Platform } from 'react-native';
import { styles } from './GenreCellStyles';
import { SecondaryColour } from '../../value';
import { Actions } from 'react-native-router-flux';

class GenreCell extends PureComponent {
  constructor(props) {
    super();
    this.flex = 1 / props.column;
  }

  render() {
    const { viewStyle } = styles;
    return (
      <View style={[viewStyle, {flex: this.flex}]}>
        { this.renderButton() }
      </View>
    )
  }

  renderButton = () => {
    if (Platform.OS == 'windows') {
      let winButton = require('react-native-elements').Button;
      return <winButton />
    } else {
      return <Button title={this.props.data} color={SecondaryColour} onPress={this.showGenreDetail} />
    }
  }

  showGenreDetail = () => {
    const { title } = this.props.data;
    let genre = title.split(' ').join('-') + '?page=';
    // console.log(title, genre);
    Actions.GenreDetail({title: title, genre: genre});
  }
}

export default GenreCell;