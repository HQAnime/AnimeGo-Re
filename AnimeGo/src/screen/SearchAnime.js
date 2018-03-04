import React, { Component } from 'react';
import { View, TextInput } from 'react-native';
import { Actions } from 'react-native-router-flux';
import { styles } from './SearchAnimeStyles';
import { AnimeList } from '../component';
import { MajorLink } from '../value';

class SearchAnime extends Component {
  constructor() {
    super()
    this.state = {keyword: ''}
    Actions.refresh({renderTitle: this.renderHeader()})
  }

  render() {
    const { keyword } = this.state;
    if (keyword.length < 3) return null;
    else {
      return <AnimeList AnimeUrl={MajorLink.Search + keyword + '&page='} showFab={false}/>
    }
  }

  renderHeader() {
    const { inputStyle } = styles;
    return <TextInput style={inputStyle} underlineColorAndroid='transparent' autoCorrect={false} onChangeText={(text) => {this.name = text}} onEndEditing={this.searchAnime}/>;
  }

  searchAnime = () => {
    this.setState({keyword: ''});
    // Clear old result
    setTimeout(() => {
      this.name = this.name.split(' ').join('%20');
      if (this.name.length < 3) return;
      else this.setState({keyword: this.name});
    }, 1000)
  }
}

export {SearchAnime};