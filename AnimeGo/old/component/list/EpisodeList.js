import React, { Component } from 'react';
import { View, Text, FlatList, Image, Linking, AsyncStorage, ToastAndroid, Platform, Alert } from 'react-native';
import EpisodeLoader from '../../helper/core/EpisodeLoader';
import EpisodeCell from '../cell/EpisodeCell';
import { LoadingIndicator, AnimeButton } from '../../component';
import { Actions } from 'react-native-router-flux';
import { isPortrait } from '../../helper/DeviceDimensions';
import { styles } from './EpisodeListStyles'
import { BlueColour, GreenColour, RedColour } from '../../value';

class EpisodeList extends React.PureComponent {
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
    this.updateColumn();
  }

  keyExtractor = (data) => data.number;  
  render() {
    const { data, episode, column } = this.state;    
    if (data.length == 0) return <LoadingIndicator />
    else {
      return (
        <View style={{flex: 1}} onLayout={this.updateColumn}>
          <FlatList data={data} keyExtractor={this.keyExtractor} numColumns={column} key={isPortrait() ? 'p' + column : 'h' + column}
            renderItem={({item}) => <EpisodeCell data={item} isLastest={item.number == episode ? true : false}/>}  
            ListFooterComponent={this.renderFooter} ListHeaderComponent={this.renderHeader} automaticallyAdjustContentInsets={false}
            onEndReached={this.loadMoreEpisode} onEndReachedThreshold={0.5}/>
        </View>
      )
    }
  }

  renderHeader = () => {
    const { name, image, plot } = this.state;
    const { mainViewStyle, titleStyle, basicTextStyle, plotStyle } = styles;
    return (
      <View style={mainViewStyle}>
        <Text numberOfLines={3} style={titleStyle}>{name}</Text>
        { this.renderInfo() }
        <Text style={plotStyle}>{plot}</Text>
        <AnimeButton title='Google it' color={BlueColour} onPress={this.searchGoogle}/>
        <Text style={basicTextStyle}>* Please consider buying its DVD</Text>
        <AnimeButton title='To-Watch' color={RedColour} onPress={this.addToList}/>
      </View>
    )
  }

  /**
   * Add this name to To-Watch list. No duplicate
   */
  addToList = () => {
    const { data, link } = this.props;    
    let animeInfo = {link: link, name: data.name};
    if (global.favList.length == 0) global.favList = [animeInfo];
    else {
      var hasAnime = false;
      for (var i = 0; i < global.favList.length; i++) {
        let anime = global.favList[i];
        if (anime.name == animeInfo.name) {
          if (Platform.OS == 'android') ToastAndroid.show('Anime has already been added', ToastAndroid.SHORT);
          else Alert.alert('Warning', 'Anime has already been added');
          hasAnime = true; break;
        }
      }
      if (!hasAnime) global.favList = global.favList.concat([animeInfo]);
    }
    AsyncStorage.setItem('@Favourite', JSON.stringify(global.favList));
  }

  /**
   * Google this anime name
   */
  searchGoogle = () => {
    let google = 'https://www.google.com/search?q=' + this.state.name.split(' ').join('%20');
    Linking.openURL(google).catch(err => console.error('An error occurred', err));
  }

  /**
   * Render anime information depending on DataSaver mode
   */
  renderInfo = () => {
    const { genre, release, episode, type, image } = this.state;    
    const { imageViewStyle, imageStyle, infoViewStyle, basicTextStyle } = styles;    
    if (global.dataSaver) {
      return (
        <View style={infoViewStyle}>
          <Text style={basicTextStyle}>{'Genre\n' + genre}</Text>
          <Text style={basicTextStyle}>{'Release\n' + release}</Text>
          <Text style={basicTextStyle}>{'Episode\n' + episode}</Text>
          <View>
            <Text style={basicTextStyle}>Type:</Text>
            <AnimeButton title={type.replace(' Anime', '')} color={GreenColour} onPress={this.goSubCategory}/>
          </View>
        </View>
      )
    } else {
      return (
        <View style={imageViewStyle}>
          <Image source={{uri: image}} style={imageStyle} resizeMode='cover'/>
          <View style={infoViewStyle}>
            <Text style={basicTextStyle}>{'Genre\n' + genre}</Text>
            <Text style={basicTextStyle}>{'Release\n' + release}</Text>
            <Text style={basicTextStyle}>{'Episode\n' + episode}</Text>
            <View>
              <Text style={basicTextStyle}>Type:</Text>
              <AnimeButton title={type.replace(' Anime', '')} color={GreenColour} onPress={this.goSubCategory}/>
            </View>
          </View>
        </View>
      )
    }
  }

  /**
   * Render footer for EpisodeList. It is either an indicator or nothing
   */
  renderFooter = () => {
    if (this.state.hasMorePage) return <LoadingIndicator />
    else return null;
  }

  /**
   * Visit this anime's category
   */
  goSubCategory = () => {
    const { type, typeLink } = this.state; 
    // To prevent infinite loop
    if (type == global.currSubCategory) Actions.pop();
    else {
      global.currSubCategory = type;
      Actions.SubCategory({title: type, link: typeLink + '?page='});
    }
  }

  /**
   * Update column number depending on orientation
   */
  updateColumn = () => {
    this.setState({column: isPortrait() ? 4 : 8});
  }

  /**
   * Loading anime first 99 episodes
   */
  loadEpisode = () => {
    const { ep_start, ep_end, id, episode, data, hasMorePage } = this.state;
    if (!hasMorePage) return;
    let source = new EpisodeLoader(ep_start, ep_end, id, episode);
    source.loadEpisode().then((animeEpisode) => {
      if (animeEpisode.length < 100) {
        // Some anime has episode 0...
        this.setState({
          data: data.concat(animeEpisode),
          hasMorePage: false,
        })  
      } else this.setState({data: data.concat(animeEpisode)})
    })
    .catch((error) => {
      console.error(error);
    });
  }

  /**
   * Loading next 99 episodes
   */
  loadMoreEpisode = () => {
    const { episode, ep_start, ep_end } = this.state;
    var new_start = ep_start + 100;
    var new_end = ep_end + 100;
    if (new_end > episode) new_end = episode;

    this.setState({
      ep_start: new_start,
      ep_end: new_end,
    }, () => {this.loadEpisode()})
  }  
}


export { EpisodeList };