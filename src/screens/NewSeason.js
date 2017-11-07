import React, { Component } from 'react';
import { View, Text } from 'react-native';
import { GoGoAnime } from '../Constant';

class NewSeason extends Component {
  componentWillMount() {
    // Loading data here
    fetch(GoGoAnime.NewRelease)
    .then((html) => html.text())
    .then((htmlText) => {
      console.log(htmlText);
    })
    .catch((error) => {
      console.error(error);
    });
  }

  render() {
    return (
      <View>
        <Text>NewSeason</Text>
      </View>
    );
  }
}

export { NewSeason };