import React, { Component } from 'react';
import { View, TextInput, Platform } from 'react-native';
import { AnimeList } from '../component/';
import { GoGoAnime } from '../Constant';
import { Actions } from 'react-native-router-flux';

class SearchAnime extends Component {
  constructor(props) {
    super(props);
    this.textInput = '';
    this.state = {animeName: ''};
    Actions.refresh({renderTitle: this.renderSearch()});
  }

  render() {
    if (this.state.animeName == '') return null;
    else return <AnimeList AnimeUrl={GoGoAnime.Search + this.state.animeName + '&page='}/>
  }

  renderSearch() {
    return (
      <View style={{width: '90%'}}>
        <TextInput autoCapitalize='none' autoCorrect={false}
          style={styles.inputStyle} autoFocus
          onChangeText={(text) => {this.textInput = text}}
          onEndEditing={this.searchAnime}
        />
      </View>
    )
  }
  
  searchAnime = () => {
    if (this.textInput.length < 3) return;
    else this.setState({animeName: this.textInput});
  }
}

const styles = {
  inputStyle: {
    height: (Platform.OS === 'ios') ? 40 : 50,
    textAlign: 'center',
    color: 'white',
  }
}

export { SearchAnime };