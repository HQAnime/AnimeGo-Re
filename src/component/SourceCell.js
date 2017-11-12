import React, { Component } from 'react';
import { View, Button, Linking, Platform, Linking } from 'react-native';
import { Colour } from '../Styles';

class SourceCell extends React.PureComponent {
  
  constructor(props) {
    super(props);
    this.animeName = this.props.data.name;
    this.link = this.props.data.source;
  }

  render() {
    return (
      <View>
        <Button title={this.props.data.name} color={Colour.GoGoAnimeOrange} onPress={this.WatchAnime} />
      </View>
    )
  }

  WatchAnime = () => {
    var currOS = Platform.OS;
    if (currOS == 'ios') {
      var Browser = require('react-native-browser');
      Browser.open(this.link);
    } else {
      Linking.openURL(this.link).catch(err => console.error('An error occurred', err));
    }
  }
}

export default SourceCell;