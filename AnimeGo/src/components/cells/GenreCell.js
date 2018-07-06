import React, { PureComponent } from 'react';
import { View, StyleSheet } from 'react-native';
import { Actions } from 'react-native-router-flux';
import { Button } from 'react-native-paper';
import { ACCENT_COLOUR } from '../../value';

class GenreCell extends PureComponent {
  render() {
    const { title } = this.props;
    return (
      <Button color={ACCENT_COLOUR} onPress={this.showGenreInfo}>{title}</Button>
    )
  }

  /**
   * Go to genre category
   */
  showGenreInfo = () => {
    const { title } = this.props;
    let genre = title.split(' ').join('-') + '?page=';
    // console.log(title, genre);
    Actions.GenreInfo({title: title, genre: genre});
  }
}

export { GenreCell };