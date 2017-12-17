import React, { Component } from 'react';
import { View, Button, Platform, Alert, Linking, processColor } from 'react-native';
import { Actions } from 'react-native-router-flux';
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
    // console.log(this.link);    
    if (Platform.OS == 'ios') Actions.PlayAnime({title: this.source, link: this.link});
    else Linking.openURL(this.link).catch(error => {console.error(error)});
  }
}

export default SourceCell;