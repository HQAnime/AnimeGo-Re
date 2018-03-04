import React, { Component } from 'react';
import { View, Text, FlatList, Image, Linking, Button } from 'react-native';
import EpisodeLoader from '../../helper/core/EpisodeLoader';
import EpisodeCell from '../cell/EpisodeCell';
import { LoadingIndicator } from '../../component';
import { Actions } from 'react-native-router-flux';
import { isPortrait } from '../../helper/DeviceDimensions';
import { styles } from './EpisodeListStyles'
import { BlueColour, GreenColour } from '../../value';

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
    const { mainViewStyle, titleStyle, basicTextStyle, plotStyle} = styles;
    return (
      <View style={mainViewStyle}>
        <Text style={titleStyle}>{name}</Text>
        { this.renderInfo() }
        <Text style={plotStyle}>{plot}</Text>
        <Button title='Google it' color={BlueColour} onPress={this.searchGoogle}/>
        <Text style={basicTextStyle}>* Please consider buying its DVD</Text>
      </View>
    )
  }

  searchGoogle = () => {
    let google = 'https://www.google.com/search?q=' + this.state.name.split(' ').join('%20');
    Linking.openURL(google).catch(err => console.error('An error occurred', err));
  }

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
            <Button title={type.replace(' Anime', '')} color={GreenColour} onPress={this.goSubCategory}/>
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
              <Button title={type.replace(' Anime', '')} color={GreenColour} onPress={this.goSubCategory}/>
            </View>
          </View>
        </View>
      )
    }
  }

  renderFooter = () => {
    if (this.state.hasMorePage) return <LoadingIndicator />
    else return null;
  }

  goSubCategory = () => {
    Actions.SubCategory({title: this.state.type, link: this.state.typeLink + '?page='});
  }

  updateColumn = () => {
    this.setState({column: isPortrait() ? 4 : 8});
  }

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