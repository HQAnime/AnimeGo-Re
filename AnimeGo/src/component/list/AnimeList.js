import React, { PureComponent } from 'react';
import { View, ActivityIndicator, Dimensions, Text, FlatList } from 'react-native';
import AnimeLoader from '../../helper/core/AnimeLoader';
import AnimeCell from '../cell/AnimeCell';
import { LoadingIndicator } from '../../component';

const isPortrait = () => {
  const dim = Dimensions.get('window');
  return dim.height >= dim.width;
};

class AnimeList extends PureComponent {

  keyExtractor = (item) => {
    // console.log(item.name + item.link);
    return item.name + item.link;
  };

  constructor(props) {
    super(props);
    this.state = {
      data: [],
      page: 1,
      hasMorePage: true,
      isRefreshing: false,
      url: props.AnimeUrl,
      columns: -1,
    };
  }

  componentWillMount() {
    console.log('Mount');
    this.loadAnime();
  }

  componentDidUpdate() {
    console.log('Update');
    this.componentWillMount();
  }

  render() {
    /* A loading indictor */
    if (this.state.data.length == 0) {
      return <LoadingIndicator />
    }

    return (
      <FlatList data={this.state.data} keyExtractor={this.keyExtractor}
        key={(isPortrait() ? 'p' : 'l')}
        renderItem={({item}) => 
          <AnimeCell data={item} width={this.state.goodWidth}/>
        } numColumns={isPortrait() ? 2 : 4} isRefreshing={false}
        ListFooterComponent={this.renderFooterComponent} />
    );
  }

  renderFooterComponent = () => {
    if (!this.state.hasMorePage) return null;
    else return (
      <LoadingIndicator />
    )
  }

  loadAnime = () => {
    // console.log(this.state.hasMorePage ? 'morePage' : 'lastPage', this.state.isRefreshing ? 'refreshing' : 'not');
    if (!this.state.hasMorePage && !this.state.isRefreshing) return;
    let loader = new AnimeLoader(this.state.url, this.state.page);
    loader.loadAnime()
    .then((animeData) => {
      console.log(this.state.url)
      if (animeData.length == 0) {
        // No more pages
        this.setState({
          hasMorePage: false,
          isRefreshing: false,
        })
      } else if (animeData.length < 20) {
        // Append data
        this.setState({
          data: this.state.data.concat(animeData),
          isRefreshing: false,
          hasMorePage: false,
        })
      } else {
        // Append data
        this.setState({
          data: this.state.data.concat(animeData),
          page: this.state.page + 1,
          isRefreshing: false,
        })
      }
    })
    .catch((error) => {
      console.error(error);
      this.setState({isRefreshing: false})
    })
  }

  refreshAnime = () => {
    this.setState({
      data: [],
      page: 1,
      hasMorePage: true,
      isRefreshing: true,
    }, () => {this.loadAnime()})
  }
}

export {AnimeList};