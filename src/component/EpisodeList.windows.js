import React, { Component } from 'react';
import { View, Text, FlatList, Image, Dimensions, Platform, Linking } from 'react-native';
import { Card, Button } from 'react-native-elements';
import EpisodeLoader from '../core/EpisodeLoader';
import { Colour, WindowsButtonStyles } from '../Styles';
import EpisodeCell from './EpisodeCell';
import { LoadingIndicator } from '../component';
import { Actions } from 'react-native-router-flux';

var width = Dimensions.get('window').width / 2;
const isPortrait = () => {
  const dim = Dimensions.get('window');
  return dim.height >= dim.width;
};
var currOS = Platform.OS;

class EpisodeList extends React.PureComponent {

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
          <FlatList data={this.state.data} keyExtractor={this.keyExtractor} numColumns={4}
            renderItem={({item}) => <EpisodeCell data={item} isLastest={item.number == this.state.episode ? true : false}/>}  
            ListFooterComponent={this.renderFooter} 
            ListHeaderComponent={this.renderHeader}
            onEndReached={this.loadMoreEpisode} onEndReachedThreshold={0.5}/>
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
          <View style={{flex: 0.5, justifyContent: 'space-around', padding: 4}}>
            <Text style={styles.centerText}>{'Genre:\n' + this.state.genre}</Text>
            <Text style={styles.centerText}>{'Release:\n' + this.state.release}</Text>
            <Text style={styles.centerText}>{'Episode:\n' + this.state.episode}</Text>
            <View>
              <Text style={{textAlign: 'center'}}>Type:</Text>
              <Button title={this.state.type.replace(' Anime', '')} backgroundColor={Colour.GoGoAnimeGreen} 
                buttonStyle={WindowsButtonStyles.buttonStyle} onPress={() => {
                console.log(this.state.typeLink);
                Actions.SubCategory({title: this.state.type, link: this.state.typeLink + '?page='})
              }} />
            </View>
          </View>
        </View>
        <Text style={{padding: 4}}>{this.state.plot}</Text>
        <View>
          <Button title='Google it' backgroundColor={Colour.GoGoAnimeBlue} 
            buttonStyle={WindowsButtonStyles.buttonStyle} onPress={() => {
              var google = 'https://www.google.com/search?q=' + this.state.name.split(' ').join('%20');
              if (currOS == 'ios') {
                var Browser = require('react-native-browser');
                Browser.open(google);
              } else {
                Linking.openURL(google).catch(err => console.error('An error occurred', err));                    
              }
            }} />
          <Text style={{textAlign: 'center', padding: 4}}>* Please consider buying its DVD</Text>
        </View>
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