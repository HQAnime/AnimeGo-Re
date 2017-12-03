import React, { Component } from 'react';
import { Alert, WebView, Linking } from 'react-native';
import { Actions } from 'react-native-router-flux';

class PlayAnime extends Component {  

  render() {
    return (
      <WebView source={{uri: this.props.link}} onError={this.goBack}/>      
    );
  }

  goBack = () => {
    Alert.alert('Error', 'Video could not be loaded\nIt will be played inside your browser');
    Actions.pop();
    Linking.openURL(this.props.link).catch(error => console.error(error));
  }
}

export { PlayAnime };