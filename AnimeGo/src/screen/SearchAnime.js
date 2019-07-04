import React, { Component } from 'react';
import { View, TextInput } from 'react-native';
import { Actions } from 'react-native-router-flux';
import { styles } from './SearchAnimeStyles';
import { AnimeList } from '../component';
import { MajorLink } from '../value';
import { Searchbar } from 'react-native-paper';

class SearchAnime extends Component {
  constructor(props) {
    super(props);
    this.state = {keyword: '', final: ''};

    this.searchEvent = null;
  }

  render() {
    const { keyword, final } = this.state;

    return (
      <View style={{flex: 1}}>
        <Searchbar placeholder='Search Anime' value={keyword} autoFocus
          onChangeText={query => this.setState({keyword: query}, this.searchAnime)}/>
        { this.renderList(final) }
      </View>
    )
  }

  renderList(keyword) {
    if (keyword.length < 3) return null;
    else {
      return <AnimeList AnimeUrl={global.domain + MajorLink.Search + keyword + '&page='} showFab={false}/>
    }
  }

  searchAnime = () => {
    const { keyword } = this.state;

    // Clear old result
    if (keyword.length < 3) return;
    else {
      this.setState({final: ''});
      let name = keyword.split(' ').join('%20');
      console.log(keyword);
      setTimeout(() => this.setState({final: name}));
    }
  }
}

export {SearchAnime};