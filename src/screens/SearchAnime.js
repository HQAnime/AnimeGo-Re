import React, { Component } from 'react';
import { View, TextInput, Platform } from 'react-native';

class SearchAnime extends Component {
  render() {
    return (
      <View>
        <TextInput
          style={styles.inputStyle}
          onChangeText={(text) => this.setState({text})}
        />
      </View>
    );
  }
}

const styles = {
  inputStyle: {
    height: 36, 
    borderColor: 'gray',
    borderBottomWidth: (Platform.OS === 'ios') ? 1 : 0,
  }
}

export { SearchAnime };