import React, { PureComponent } from 'react';
import { ActivityIndicator, Text, Platform, View, Dimensions } from 'react-native';
import GridView from 'react-native-super-grid';
import AnimeLoader from '../../core/AnimeLoader';
import AnimeCell from '../cells/AnimeCell';
import { moderateScale } from 'react-native-size-matters';
import { Actions } from 'react-native-router-flux';
import { ProgressBar } from '../../components';

class AnimeList extends PureComponent {
  constructor(props) {
    super(props);
    console.log(props.AnimeUrl)
    this.state = {
      data: [],
      page: 1,
      hasMorePage: true,
      isRefreshing: false,
      url: props.AnimeUrl,
    };
    // Loading anime
    this.loadAnime();
  }

  componentDidUpdate() {
    this.setState({url: this.props.AnimeUrl})
    this.loadAnime();
  }

  render() {
    const { data, isRefreshing } = this.state;
    console.log(data)
    if (data.length == 0) return <ProgressBar />
    else {
      return (
        <View style={{flex: 1}}>
          <GridView items={data} itemDimension={moderateScale(256, 0.15)} spacing={2} renderItem={item => <AnimeCell data={item}/>} 
            ListFooterComponent={this.renderFooter} onEndReached={this.loadAnime} onEndReachedThreshold={0.5} extraData={this.state.url}/>
        </View>
      )
    }
  }

  renderHeader = () => {
    return <ProgressBar />
  }

  renderFooter = () => {
    if (!this.state.hasMorePage) return null;
    else return <ProgressBar />
  }

  loadAnime = () => {
    const { hasMorePage, isRefreshing, url, page, data } = this.state; 
    if (!hasMorePage && !isRefreshing) return;
    let loader = new AnimeLoader(url, page);
    loader.loadAnime().then(([animeData, count]) => {
      if (animeData == undefined || count == undefined) {
        Actions.pop();
      } else {
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
      }
    })
    .catch((error) => {
      console.error(error);
      this.setState({isRefreshing: false, hasMorePage: false})
    })
  }
}

export { AnimeList };