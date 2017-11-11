import React, { Component } from 'react';
import { WebView } from 'react-native';
import { Actions } from 'react-native-router-flux';

class PlayVideo extends Component {
  render() {
    return (
      <WebView source={this.props.link} onError={Actions.pop()}/>
    );
  }
}

export { PlayVideo };