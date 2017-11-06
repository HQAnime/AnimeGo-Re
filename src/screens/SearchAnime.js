import React, { Component } from 'react';
import { View, TextInput } from 'react-native';

class SearchAnime extends Component {
  render() {
    return (
      <View>
        <TextInput
          style={{height: 40, borderColor: 'gray'}}
          onChangeText={(text) => this.setState({text})}
        />
      </View>
    );
  }
}

export { SearchAnime };