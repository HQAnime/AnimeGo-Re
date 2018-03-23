import React, { Component } from 'react';
import { Platform } from 'react-native';

class AnimeButton extends Component {
  render() {
    const { onPress, color, title } = this.props;
    if (Platform.OS == 'windows') {
      let Button = require('react-native-elements').Button;
      return (
        <Button title={title} onPress={onPress} buttonStyle={{backgroundColor: color}}/>
      )
    } else {
      let Button = require('react-native').Button;
      return (
        <Button title={title} onPress={onPress} color={color}/>
      )  
    }
  }
}

export {AnimeButton};