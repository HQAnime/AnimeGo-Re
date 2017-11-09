import React, { Component } from 'react';
import { RefreshControl, Linking, TouchableOpacity, Image, FlatList, View, Text, ActivityIndicator } from 'react-native';
import { Colour, RecentReleaseStyles } from '../Styles';
import AnimeLoader from '../core/AnimeLoader';

class AnimeList extends Component {

  keyExtractor = (item, index) => item.id;

  constructor(props) {
    super(props);
    this.state = {
      data: [],
      page: 1,
      hasMorePage: true,
      isRefreshing: false,
      url: this.props.AnimeUrl,
    };
  }

  componentWillMount() {
     this.loadAnime();
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
      <FlatList
        data={this.state.data} keyExtractor={item => item.name}
        renderItem={({item}) => 
        <View style={{padding: 10}}>
          <TouchableOpacity onPress={() => Linking.openURL(item.link).catch(err => console.error('An error occurred', err))}>
            <Text>{item.name}</Text>
            <Text>{item.episode}</Text>
            <Image source={{uri: item.thumbnail}} style={{width: 225, height: 326}} />
          </TouchableOpacity>
        </View>
        } onEndReached={this.loadAnime} onEndReachedThreshold={0} 
        onRefresh={this.refreshAnime} refreshing={this.state.isRefreshing}
        contentContainerStyle={{alignItems: 'center'}} ListFooterComponent={
          <ActivityIndicator color={Colour.GoGoAnimeOrange} style={loadingStyle} size='large'/>
        }/>
    );
  }

  loadAnime = () => {
    if (!this.state.hasMorePage && !this.state.isRefreshing) return;
    let loader = new AnimeLoader(this.state.url, this.state.page);
    loader.loadAnime()
    .then((animeData) => {
      console.log(animeData);
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