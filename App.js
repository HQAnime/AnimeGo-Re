import React, { Component } from 'react';
import { View, Text } from 'react-native';
import { StackNavigator } from 'react-navigation';

export default class App extends Component {
  static navigationOptions = {
    title: 'GoGoAnime',
  }

  render() {
    return (
      <View>
        <Text>Hello World</Text>
      </View>
    );
  }
}

