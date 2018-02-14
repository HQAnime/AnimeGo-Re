import React, { Component } from 'react';
import { View, ActivityIndicator, Dimensions, Text, FlatList } from 'react-native';
import { Colour, RecentReleaseStyles } from '../Styles';
import AnimeLoader from '../core/AnimeLoader';
import AnimeCell from './AnimeCell';
import { LoadingIndicator } from '../component';

const isPortrait = () => {
  const dim = Dimensions.get('window');
  return dim.height >= dim.width;
};

class AnimeList extends React.PureComponent {

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
    this.getNumColumns();
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
      <View style={{flex: 1}} onLayout={this.getNumColumns}>
        <FlatList data={this.state.data} keyExtractor={this.keyExtractor}
          key={(isPortrait() ? 'portrait' + this.state.columns: 'landscape' + this.state.columns)}
          renderItem={({item}) => 
            <AnimeCell data={item} width={this.state.goodWidth}/>
          } onEndReached={this.loadAnime} onEndReachedThreshold={0.5} numColumns={this.state.columns}
          onRefresh={this.refreshAnime} refreshing={this.state.isRefreshing}
          ListFooterComponent={this.renderFooterComponent} />
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
    const { width } = Dimensions.get('window');
    columns = Math.floor(width / 200);
    if (columns < 2) columns = 2;
    if (columns > 2) columns = 4;
    if (columns == this.state.columns) return;
    var goodWidth = width / columns;
    
    this.setState({
      columns: columns,
      goodWidth: goodWidth,
    })
  }

  loadAnime = () => {
    // console.log(this.state.hasMorePage ? 'morePage' : 'lastPage', this.state.isRefreshing ? 'refreshing' : 'not');
    if (!this.state.hasMorePage && !this.state.isRefreshing) return;
    setTimeout(() => {
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
    }, 500);
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