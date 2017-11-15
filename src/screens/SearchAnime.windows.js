import React, { Component } from 'react';
import { View, TextInput, Platform } from 'react-native';
import { AnimeList } from '../component/';
import { GoGoAnime } from '../Constant';
import { Actions } from 'react-native-router-flux';

class SearchAnime extends Component {
  constructor(props) {
    super(props);
    this.textInput = '';
    this.state = {
      animeName: ''
    };
  }

  render() {
    if (this.state.animeName == '') {
      return (
        <View>
          <TextInput autoCapitalize='none' autoCorrect={false}
            style={styles.inputStyle} autoFocus
            onChangeText={(text) => {this.textInput = text}}
            onEndEditing={this.searchAnime}
          />
        </View>
      )
    } else {
      return <AnimeList AnimeUrl={GoGoAnime.Search + this.state.animeName + '&page='}/>
    }
  }
  
  searchAnime = () => {
    if (this.textInput.length < 3) return;
    else {
      Actions.refresh({title: this.textInput});
      this.setState({
        animeName: this.textInput,
      });
    }
  }
}

const styles = {
  inputStyle: {
    height: 30,
    textAlign: 'center',
    borderColor: 'gray',
    alignSelf: 'center',
    borderBottomWidth: (Platform.OS === 'ios') ? 1 : 0,
  }
}

export { SearchAnime };