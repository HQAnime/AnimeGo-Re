import React, { Component } from 'react';
import { View, Text, FlatList, Button, Image, Dimensions } from 'react-native';
import { Card } from 'react-native-elements';
import EpisodeLoader from '../core/EpisodeLoader';
import { Colour } from '../Styles';
import EpisodeCell from './EpisodeCell';
import { LoadingIndicator } from '../component';

var width = Dimensions.get('window').width / 2;
const isPortrait = () => {
  const dim = Dimensions.get('screen');
  return dim.height >= dim.width;
};

class EpisodeList extends Component {

  keyExtractor = (data) => data.number;

  constructor(props) {
    super(props);
    var data = this.props.data;
    this.state = {
      name: data.name, type: data.type, typeLink: data.typeLink,
      genre: data.genre, release: data.release, episode: data.episode,
      plot: data.plot, image: data.image, id: data.id, 
      ep_start: 0, ep_end: 99, ascending: true, hasMorePage: true,
      data: [], orientation: isPortrait() ? 'portrait' : 'landscape',
    }
  }

  componentWillMount() {
    this.loadEpisode();
  }

  render() {
    if (this.state.data.length == 0) {
      /* A loading indictor */
      return <LoadingIndicator />
    } else {
      return (
        <View style={{flex: 1}} onLayout={this.updateView}>
          <FlatList data={this.state.data} keyExtractor={this.keyExtractor}
            renderItem={({item}) => <EpisodeCell data={item} />}  numColumns={4}
            ListFooterComponent={this.renderFooter} 
            ListHeaderComponent={this.renderHeader}
            onEndReached={this.loadMoreEpisode} onEndReachedThreshold={0}/>
        </View>
      )
    }
  }

  updateView = () => {
    var currOrientation = isPortrait() ? 'portrait' : 'landscape';
    if (this.state.orientation == currOrientation) return;
    this.setState({
      orientation: currOrientation,
    })
  }

  loadEpisode = () => {
    if (!this.state.hasMorePage) return;
    let source = new EpisodeLoader(this.state.ep_start, this.state.ep_end, this.state.id, this.state.episode);
    source.loadEpisode()
    .then((animeEpisode) => {
      if ((this.state.ep_start == 0 && animeEpisode.length < 99) 
        || (this.state.ep_start > 0 && animeEpisode.length < 100)) {
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

  renderFooter = () => {
    if (this.state.hasMorePage) {
      return (
        <LoadingIndicator />
      )
    } else return null;
  }

  renderHeader = () => {
    return (
      <Card title={this.state.name}>
        <View style={{flexDirection: 'row', height: width * 1.429}}>
          <View style={{flex: 0.5}}>
            <Image source={{uri: this.state.image}} resizeMode='cover' style={{flex: 1}}/>
          </View>
          <View style={{flex: 0.5, justifyContent: 'space-around'}}>
            <Text style={styles.centerText}>{'Category:\n' + this.state.type}</Text>
            <Text style={styles.centerText}>{'Genre:\n' + this.state.genre}</Text>
            <Text style={styles.centerText}>{'Release:\n' + this.state.release}</Text>
            <Text style={styles.centerText}>{'Episode:\n' + this.state.episode}</Text>
          </View>
        </View>
        <Text>{'\n' + this.state.plot}</Text>
      </Card>
    )
  }
}

const styles = {
  centerText: {
    textAlign: 'center',
  }
}

export { EpisodeList };