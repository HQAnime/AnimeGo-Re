import React, { Component } from 'react';
import { Alert, WebView } from 'react-native';
import { Actions } from 'react-native-router-flux';

class PlayVideo extends React.PureComponent {
  render() {
    return (
      <WebView source={{uri: this.props.link}} renderError={this.failLoading}
        onError={this.failLoading} />
    );
  }

  failLoading = () => {
    Alert.alert('Video could not be loaded');
    Actions.pop();
  }
}

export { PlayVideo };