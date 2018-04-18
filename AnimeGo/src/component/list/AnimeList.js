import React, { PureComponent } from 'react';
import { ActivityIndicator, Text, Platform, View, Dimensions } from 'react-native';
import GridView from 'react-native-super-grid';
import AnimeLoader from '../../helper/core/AnimeLoader';
import AnimeCell from '../cell/AnimeCell';
import { LoadingIndicator, FabButton } from '../../component';
import { moderateScale } from 'react-native-size-matters';

class AnimeList extends PureComponent {
  constructor(props) {
    super(props);
    this.state = {
      data: [],
      page: 1,
      hasMorePage: true,
      isRefreshing: false,
      url: props.AnimeUrl,
    };
  }

  componentWillMount() {
    // Loading anime
    this.loadAnime();
  }

  render() {
    const { data, isRefreshing } = this.state;
    if (data.length == 0) return <LoadingIndicator />
    else {
      return (
        <View style={{flex: 1}}>
          <GridView items={data} itemDimension={moderateScale(128, 0.15)} spacing={2} renderItem={item => <AnimeCell data={item}/>} 
            refreshing={isRefreshing} ListFooterComponent={this.renderFooterComponent} automaticallyAdjustContentInsets={false}
            onRefresh={this.refreshAnime} onEndReached={this.loadAnime} onEndReachedThreshold={0.5} showsVerticalScrollIndicator={false} />
          { this.renderFabButton() }
        </View>
      )
    }
  }

  // Sometimes, FAB is not needed
  renderFabButton = () => {
    if (this.props.showFab != false && Platform.OS == 'android') return <FabButton />
    else return null;
  }

  refreshAnime = () => {
    this.setState({
      data: [],
      page: 1,
      hasMorePage: true,
      isRefreshing: false,
    }, () => this.loadAnime())
  }

  renderFooterComponent = () => {
    if (!this.state.hasMorePage) return null;
    else return <LoadingIndicator />
  }

  loadAnime = () => {
    console.log('Loading anime');
    const { hasMorePage, isRefreshing, url, page, data } = this.state;
    if (!hasMorePage && !isRefreshing) return;
    let loader = new AnimeLoader(url, page);
    loader.loadAnime().then(([animeData, count]) => {
      console.log(count);
      if (count == 0) {
        // No more pages
        this.setState({
          hasMorePage: false,
          isRefreshing: false,
        })
      } else if (count < 20) {
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
      this.setState({isRefreshing: false, hasMorePage: false})
    })
  }
}

export {AnimeList};