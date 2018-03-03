import React, { Component } from 'react';
import { View, Text, FlatList, Image, Linking } from 'react-native';
import EpisodeLoader from '../../helper/core/EpisodeLoader';
import EpisodeCell from '../cell/EpisodeCell';
import { LoadingIndicator, SmartTouchable } from '../../component';
import { Actions } from 'react-native-router-flux';
import { isPortrait } from '../../helper/DeviceDimensions';

class EpisodeList extends React.PureComponent {

  keyExtractor = (data) => data.number;

  constructor(props) {
    super();
    const { name, type, typeLink, episode, genre, release, plot, image, id } = props.data;
    this.state = {
      name: name, type: type, typeLink: typeLink,
      genre: genre, release: release, episode: episode,
      plot: plot, image: image, id: id, 
      ep_start: 0, ep_end: 99, ascending: true, hasMorePage: true,
      data: []
    }
  }

  componentWillMount() {
    this.loadEpisode();
  }

  render() {
    const { data, episode } = this.state;    
    if (data.length == 0) return <LoadingIndicator />
    else {
      return (
        <View style={{flex: 1}} onLayout={this.updateColumn}>
          <FlatList data={data} keyExtractor={this.keyExtractor} numColumns={4}
            renderItem={({item}) => <EpisodeCell data={item} isLastest={item.number == episode ? true : false}/>}  
            ListFooterComponent={this.renderFooter} 
            ListHeaderComponent={this.renderHeader}
            onEndReached={this.loadMoreEpisode} onEndReachedThreshold={0.5}/>
        </View>
      )
    }
  }

  renderHeader = () => {
    return (
      null
    )
  }

  renderFooter = () => {
    if (this.state.hasMorePage) return <LoadingIndicator />
    else return null;
  }

  updateColumn = () => {
    
  }

  loadEpisode = () => {
    if (!this.state.hasMorePage) return;
    let source = new EpisodeLoader(this.state.ep_start, this.state.ep_end, this.state.id, this.state.episode);
    source.loadEpisode()
    .then((animeEpisode) => {
      if (animeEpisode.length < 100) {
        // Some anime has episode 0...
        this.setState({
          data: this.state.data.concat(animeEpisode),
          hasMorePage: false,
        })  
      } else {
        this.setState({
          data: this.state.data.concat(animeEpisode),
        })
      }  
    })
    .catch((error) => {
      console.error(error);
    });
  }

  loadMoreEpisode = () => {
    var lastest = this.state.episode;
    var new_start = this.state.ep_start + 100;
    var new_end = this.state.ep_end + 100;
    if (new_end > lastest) new_end = lastest;

    this.setState({
      ep_start: new_start,
      ep_end: new_end,
    }, () => {this.loadEpisode()})
  }  
}


export { EpisodeList };