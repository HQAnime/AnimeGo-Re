import React, { Component } from 'react';
import { View, Button, Linking } from 'react-native';
import { Colour } from '../Styles';

class SourceCell extends Component {
  
  render() {
    return (
      <View>
        <Button title={this.props.data.name} color={Colour.GoGoAnimeOrange} onPress={this.WatchAnime} />
      </View>
    )
  }

  WatchAnime = () => {
    Linking.openURL(this.props.data.source).catch(err => console.error('An error occurred', err));
  }
}

export default SourceCell;