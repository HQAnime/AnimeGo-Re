import React, { Component } from 'react';
import { View, FlatList, ActivityIndicator, Dimensions, Text } from 'react-native';
import { Colour, RecentReleaseStyles } from '../Styles';
import AnimeLoader from '../core/AnimeLoader';
import AnimeCell from './AnimeCell';
import { LoadingIndicator } from '../component';

const isPortrait = () => {
  const dim = Dimensions.get('screen');
  return dim.height >= dim.width;
};

class AnimeList extends Component {

  keyExtractor = (item) => item.link;

  constructor(props) {
    super(props);
    this.state = {
      data: [],
      page: 1,
      hasMorePage: true,
      isRefreshing: false,
      url: this.props.AnimeUrl,
      columns: -1,
    };
  }

  componentWillMount() {
     this.loadAnime();
     this.getNumColumns();
  }

  render() {
    /* A loading indictor */
    if (this.state.data.length == 0) {
      return <LoadingIndicator />
    }

    return (
      <View style={{flex: 1}} onLayout={this.getNumColumns}>
        <FlatList data={this.state.data} keyExtractor={this.keyExtractor} 
          key={(isPortrait() ? 'portrait' : 'landscape')}
          renderItem={({item}) => 
            <AnimeCell data={item} width={this.state.goodWidth}/>
          } onEndReached={this.loadAnime} onEndReachedThreshold={1} numColumns={this.state.columns}
          onRefresh={this.refreshAnime} refreshing={this.state.isRefreshing}
          ListFooterComponent={this.renderFooterComponent}/>
      </View>
    );
  }

  renderFooterComponent = () => {
    if (!this.state.hasMorePage) return null;
    else return (
      <LoadingIndicator />
    )
  }

  getNumColumns = () => {
    // console.log(isPortrait() ? 'portrait' : 'landscape');
    const { width, height } = Dimensions.get('window');
    columns = Math.floor(width / 200);
    if (columns < 2) columns = 2;
    else if (columns > 6) columns = 6;
    goodWidth = Math.round(width / columns);

    // Prevent unnecessary updates
    if (columns == this.state.columns) return;    

    // console.log(columns, goodWidth);
    this.setState({
      columns: columns,
      goodWidth: goodWidth,
    })
  }

  loadAnime = () => {
    // console.log(this.state.hasMorePage ? 'morePage' : 'lastPage', this.state.isRefreshing ? 'refreshing' : 'not');
    if (!this.state.hasMorePage && !this.state.isRefreshing) return;
    let loader = new AnimeLoader(this.state.url, this.state.page);
    loader.loadAnime()
    .then((animeData) => {
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

export { AnimeList };