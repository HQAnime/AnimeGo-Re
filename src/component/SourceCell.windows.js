import React, { Component } from 'react';
import { View, Platform, Alert, Linking, processColor } from 'react-native';
import { Button } from 'react-native-elements';
import { Actions } from 'react-native-router-flux';
import { Colour, WindowsButtonStyles } from '../Styles';
import VideoLoader from '../core/VideoLoader';

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
          <Button title={this.source} buttonStyle={WindowsButtonStyles.buttonStyle} backgroundColor={Colour.GoGoAnimeRed} onPress={this.WatchAnimeInApp} />
        </View>
      )
    } else if (this.source.includes('Download')) {
      return (
        <View style={{padding: 2}}>
          <Button title={this.source} buttonStyle={WindowsButtonStyles.buttonStyle} backgroundColor={Colour.GoGoAnimeGreen} onPress={this.WatchAnime} />
        </View>
      )
    } else {
      return (
        <View style={{padding: 2}}>
          <Button title={this.source} buttonStyle={WindowsButtonStyles.buttonStyle} backgroundColor={Colour.GoGoAnimeOrange} onPress={this.WatchAnime} />
        </View>
      )
    }
  }

  WatchAnimeInApp = () => {
    let loader = new VideoLoader(this.link);
    loader.getVideoUrl()
    .then((url) => {
      if (url != '') {
        if (!url.includes('https')) url = 'https:' + url;
        Actions.PlayAnime({title: this.source, link: url});
      }
    })
    .catch((error) => {
      console.error(error);
    })
  }

  WatchAnime = () => {
    console.log(this.link);
    // Only for windows
    Actions.PlayAnime({title: this.source, link: this.link})
  }
}

export default SourceCell;