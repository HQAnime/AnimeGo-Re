import React, { Component } from 'react';
import { Alert, WebView } from 'react-native';
import { Actions } from 'react-native-router-flux';

class PlayAnime extends Component {  

  render() {
    return (
      <WebView source={{uri: this.props.link}} />      
    );
  }

  goBack = () => {
    Alert.alert('Error', 'Video could not be played');
    Actions.pop();
  }
}

export { PlayAnime };