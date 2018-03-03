import React, { Component } from 'react';
import { View, Button, Platform, Alert, Linking } from 'react-native';
import { Actions } from 'react-native-router-flux';

class SourceCell extends React.PureComponent {
  constructor(props) {
    super();
    const { name, source } = props.data;
    this.source = name;
    this.link = source;
  }

  render() {
    return this.renderButton()
  }

  renderButton = () => {
    if (this.source.includes('Vidstreaming')) {
      // This is recommened
      return (
        <View style={{padding: 2}}>
          <Button title={this.source} onPress={this.WatchAnime} />
        </View>
      )
    } else if (this.source.includes('Download')) {
      return (
        <View style={{padding: 2}}>
          <Button title={this.source} onPress={this.WatchAnime} />
        </View>
      )
    } else {
      return (
        <View style={{padding: 2}}>
          <Button title={this.source} onPress={this.WatchAnime} />
        </View>
      )
    }
  }

  WatchAnime = () => {
    // console.log(this.link);    
    Linking.openURL(this.link).catch(error => {console.error(error)});
  }
}

export default SourceCell;