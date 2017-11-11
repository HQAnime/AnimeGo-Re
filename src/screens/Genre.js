import React, { Component } from 'react';
import { View, Text } from 'react-native';
import { GenreList } from '../component/GenreList'; 

class Genre extends Component {
  render() {
    return (
      <GenreList />
    );
  }
}

export { Genre };