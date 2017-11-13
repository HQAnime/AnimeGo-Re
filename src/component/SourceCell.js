import React, { Component } from 'react';
import { View, Button, Platform, Linking } from 'react-native';
import { Colour } from '../Styles';

class SourceCell extends React.PureComponent {
  
  constructor(props) {
    super(props);
    this.source = this.props.data.name;
    this.animeName = this.props.data.name;
    this.link = this.props.data.source;
  }

  render() {
    return (
      this.renderButton()
    )
  }

  renderButton = () => {
    if (this.source.includes('Vidstreaming')) {
      // This is recommened
      return (
        <View style={{padding: 2}}>
          <Button title={this.source} color={Colour.GoGoAnimeRed} onPress={this.WatchAnime} />
        </View>
      )
    } else if (this.source.includes('Download')) {
      return (
        <View style={{padding: 2}}>
          <Button title={this.source} color={Colour.GoGoAnimeGreen} onPress={this.WatchAnime} />
        </View>
      )
    } else {
      return (
        <View style={{padding: 2}}>
          <Button title={this.source} color={Colour.GoGoAnimeOrange} onPress={this.WatchAnime} />
        </View>
      )
    }
  }

  WatchAnime = () => {
    console.log(this.link);
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