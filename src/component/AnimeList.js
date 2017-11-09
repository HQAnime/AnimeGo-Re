import React, { Component } from 'react';
import { View, FlatList, ActivityIndicator, Dimensions } from 'react-native';
import { Colour, RecentReleaseStyles } from '../Styles';
import AnimeLoader from '../core/AnimeLoader';
import AnimeCell from './AnimeCell';

const isPortrait = () => {
  const dim = Dimensions.get('screen');
  return dim.height >= dim.width;
};

class AnimeList extends Component {

  keyExtractor = (item) => item.name;

  constructor(props) {
    super(props);
    this.state = {
      data: [],
      page: 1,
      hasMorePage: true,
      isRefreshing: false,
      url: this.props.AnimeUrl,
      columns: 2,
    };
  }

  componentWillMount() {
     this.loadAnime();
     this.getNumColumns();
  }

  render() {
    /* A loading indictor */
    if (this.state.data == '') {
      return (
        <View>
          <ActivityIndicator color={Colour.GoGoAnimeOrange} style={loadingStyle} size='large'/>
        </View>
      )
    }

    return (
      <View style={{flex: 1}} onLayout={this.getNumColumns}>
        <FlatList data={this.state.data} keyExtractor={this.keyExtractor} 
          key={(isPortrait() ? 'portrait' : 'landscape')}
          renderItem={({item}) => 
            <AnimeCell data={item} width={this.state.goodWidth}/>
          } onEndReached={this.loadAnime} onEndReachedThreshold={0} numColumns={this.state.columns}
          onRefresh={this.refreshAnime} refreshing={this.state.isRefreshing}
          ListFooterComponent={this.renderFooterComponent}/>
      </View>
    );
  }

  renderFooterComponent = () => {
    if (!this.state.hasMorePage) return null;
    else return (
      <ActivityIndicator color={Colour.GoGoAnimeOrange} style={loadingStyle} size='large'/>
    )
  }

  getNumColumns = () => {
    console.log(isPortrait() ? 'portrait' : 'landscape');
    const { width, height } = Dimensions.get('window');
    columns = Math.floor(width / 200);
    if (columns < 2) columns = 2;
    else if (columns > 6) columns = 6;
    goodWidth = Math.round(width / columns);

    if (columns == this.state.columns) return;    

    console.log(columns, goodWidth);
    this.setState({
      columns: columns,
      goodWidth: goodWidth,
    })
  }

  loadAnime = () => {
    if (!this.state.hasMorePage && !this.state.isRefreshing) return;
    let loader = new AnimeLoader(this.state.url, this.state.page);
    loader.loadAnime()
    .then((animeData) => {
      // console.log(animeData);
      if (animeData == []) {
       // No more pages
       this.setState({
         hasMorePage: false,
         isRefreshing: false,
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

const { loadingStyle } = RecentReleaseStyles;

export { AnimeList };