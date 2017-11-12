import React, { Component } from 'react';
import { WebView, Alert } from 'react-native';
import { Actions } from 'react-native-router-flux';

class PlayVideo extends React.PureComponent {
  render() {
    return (
      <WebView source={{uri: this.props.link}} onError={this.failLoading}/>
    );
  }

  failLoading = () => {
    Alert.alert('Website could not be loaded');
    Actions.pop();
  }
}

export { PlayVideo };