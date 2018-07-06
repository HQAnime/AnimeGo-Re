import React, { Component } from 'react';
import { View, Text, FlatList, Dimensions, Alert } from 'react-native';
import AnimeSourceLoader from '../../core/AnimeSourceLoader';
import { Actions } from 'react-native-router-flux';
import { GreenColour, AnimeGoColour, ACCENT_COLOUR } from '../../value';
import { styles } from './SourceListStyles';
import { ProgressBar } from '../common/ProgressBar';
import { SourceCell } from '../cells/SourceCell';
import { Button } from 'react-native-paper';

class SourceList extends Component {
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

  keyExtractor = (data) => data.source;
  render() {
    const { data } = this.state;
    if (data.length == 0) return <ProgressBar />
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
        <Button raised primary onPress={this.infoBtnPressed}>{this.state.name}</Button>
        <View style={buttonGroupStyle}>
          <View style={buttonStyle}>
            <Button raised dark color={ACCENT_COLOUR} onPress={this.prevEpisode}>{'<<  Previous'}</Button>
          </View>
          <View style={buttonStyle}>
            <Button raised dark color={ACCENT_COLOUR} onPress={this.nextEpisode}>{'Next  >>'}</Button>           
          </View>
        </View>
      </View>
    )
  }
  
  prevEpisode = () => {
    const { prev } = this.state;
    if (prev == undefined) Alert.alert('First Episode', 'this is the first episode of this anime');
    else {
      Actions.pop();
      Actions.WatchAnime({title: 'Episode ' + prev.split('-').pop(), link: prev, fromInfo: false});      
    }
  }

  nextEpisode = () => {
    const { next } = this.state;
    if (next == undefined) Alert.alert('Last Episode', 'this is currently the last episode of this anime');    
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