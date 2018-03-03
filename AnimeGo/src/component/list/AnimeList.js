import React, { PureComponent } from 'react';
import { View, ActivityIndicator, Dimensions, Text, FlatList } from 'react-native';
import AnimeLoader from '../../helper/core/AnimeLoader';
import AnimeCell from '../cell/AnimeCell';
import { LoadingIndicator } from '../../component';

const isPortrait = () => {
  const dim = Dimensions.get('window');
  return dim.height >= dim.width;
}

class AnimeList extends PureComponent {
  constructor(props) {
    super(props);
    this.state = {
      data: [],
      page: 1,
      hasMorePage: true,
      isRefreshing: false,
      url: props.AnimeUrl,
      column: isPortrait ? 2 : 4
    };
  }

  componentWillMount() {
    // Loading anime
    this.loadAnime();
    this.updateColumn();
  }

  animeKey = (item, index) => {
    return item.link;
  }

  updateColumn = () => {
    this.setState({column: isPortrait ? 2 : 4});
    console.log(this.state.column)
  }

  render() {
    const { data, isRefreshing, column } = this.state;
    if (data.length == 0) return <LoadingIndicator />
    else {
      return (
        <FlatList data={data} keyExtractor={this.animeKey} renderItem={({item}) => <AnimeCell data={item}/>} 
        key={(isPortrait() ? 'p' : 'l')} numColumns={(isPortrait() ? 2 : 4)} refreshing={isRefreshing}
        onRefresh={this.refreshAnime} ListFooterComponent={this.renderFooterComponent()}/>
      )
    }
  }

  refreshAnime = () => {
    this.setState({
      data: [],
      page: 1,
      hasMorePage: true,
      isRefreshing: false,
    }, () => this.loadAnime())
  }

  renderFooterComponent() {
    if (!this.state.hasMorePage) return null;
    else return <LoadingIndicator />
  }

  loadAnime() {
    const { hasMorePage, isRefreshing, url, page, data } = this.state;
    if (!hasMorePage && !isRefreshing) return;
    let loader = new AnimeLoader(url, page);
    loader.loadAnime().then((animeData) => {
      if (animeData.length == 0) {
        // No more pages
        this.setState({
          hasMorePage: false,
          isRefreshing: false,
        })
      } else if (animeData.length < 20) {
        // Append data
        this.setState({
          data: data.concat(animeData),
          isRefreshing: false,
          hasMorePage: false,
        })
      } else {
        // Append data
        this.setState({
          data: data.concat(animeData),
          page: page + 1,
          isRefreshing: false,
        })
      }
    })
    .catch((error) => {
      console.error(error);
      this.setState({isRefreshing: false})
    })
  }
}

export {AnimeList};