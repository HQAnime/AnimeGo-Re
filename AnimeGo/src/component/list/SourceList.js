import React, { Component } from 'react';
import { View, Text, FlatList, Dimensions, Alert } from 'react-native';
import AnimeSourceLoader from '../../helper/core/AnimeSourceLoader';
import SourceCell from '../cell/SourceCell';
import { LoadingIndicator, AnimeButton } from '../../component';
import { Actions } from 'react-native-router-flux';
import { SecondaryColour, RedColour, GreenColour, AnimeGoColour } from '../../value';
import { styles } from './SourceListStyles';

class SourceList extends Component {

  keyExtractor = (data) => data.source;

  constructor(props) {
    super(props);
    this.state = {
      data: [],
      name: '', link: '',
      prev: '', next: ''
    }
  }

  componentWillMount() {
    let source = new AnimeSourceLoader(this.props.link);
    source.loadSource().then(([animeSource, prev, next]) => {
      if (animeSource.length == 0) return;
      this.setState({
        data: animeSource,
        name: animeSource[1].animeName,
        link: animeSource[1].infoLink,
        prev: prev, next: next
      })  
    })
    .catch((error) => {
      console.error(error);
    });
  }

  render() {
    const { data } = this.state;
    if (data.length == 0) return <LoadingIndicator />
    else {
      return (
        <View>
          <FlatList keyExtractor={this.keyExtractor} ListHeaderComponent={this.renderHeader} ListFooterComponent={this.renderFooter}
            data={data} renderItem={({item}) => <SourceCell data={item}/>}/>
        </View>
      )
    }
  }

  renderFooter = () => {
    return <Text style={styles.adStyle}>{'Ads are from websites themselves.\nThis app does not have any controls over it.'}</Text>
  }

  renderHeader = () => {
    const { headerViewStyle, textStyle, buttonGroupStyle, buttonStyle } = styles;
    return (
      <View style={headerViewStyle}>
        <Text style={textStyle}>Anime Detail</Text>
        <AnimeButton title={this.state.name} onPress={this.infoBtnPressed} color={GreenColour}/>
        <View style={buttonGroupStyle}>
          <View style={buttonStyle}>
            <AnimeButton title='<<  Previous' onPress={this.prevEpisode} color={AnimeGoColour}/>
          </View>
          <View style={buttonStyle}>
            <AnimeButton title='Next  >>' onPress={this.nextEpisode} color={AnimeGoColour}/>               
          </View>
        </View>
      </View>
    )
  }
  
  prevEpisode = () => {
    const { prev } = this.state;
    if (prev == '') Alert.alert('First Episode', 'this is the first episode of this anime');
    else {
      Actions.pop();
      Actions.WatchAnime({title: 'Episode ' + prev.split('-').pop(), link: prev, fromInfo: false});      
    }
  }

  nextEpisode = () => {
    const { next } = this.state;
    if (next == '') Alert.alert('Last Episode', 'this is currently the last episode of this anime');    
    else {
      Actions.pop();
      Actions.WatchAnime({title: 'Episode ' + next.split('-').pop(), link: next, fromInfo: false});  
    }    
  }

  infoBtnPressed = () => {
    // In case user wants infinite loop
    const { name, link } = this.state;
    if (this.props.fromInfo) Actions.pop();
    else Actions.AnimeDetail({title: name, link: link});
  }
}

export { SourceList };