import React, { Component } from 'react';
import { View, Button, Platform, Alert, Linking } from 'react-native';
import { Action, Actions } from 'react-native-router-flux';
import { Colour } from '../Styles';

class SourceCell extends React.PureComponent {
  
  constructor(props) {
    super(props);
    this.source = this.props.data.name;
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
          <Button title={this.source} color={Colour.GoGoAnimeRed} onPress={this.WatchAnimeInApp} />
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

  WatchAnimeInApp = () => {
    Actions.PlayAnime({title: this.source, link: this.link});
  }

  WatchAnime = () => {
    console.log(this.link);

    if (Platform.OS == 'ios') {
      var Browser = require('react-native-browser');
      Browser.open(this.link, {
        showPageTitles: false,
      });
    } else {
      Linking.openURL(this.link).catch(error => {console.error(error)});
    }
  }
}

export default SourceCell;