import React, { Component } from 'react';
import { View, Alert, Dimensions } from 'react-native';
import { Button } from 'react-native-elements';
import { Colour } from '../Styles';
import { Actions } from 'react-native-router-flux'; 

const { width } = Dimensions.get('window');

class EpisodeCell extends React.PureComponent {
  
  constructor(props) {
    super(props);
    this.episode = this.props.data.number;
    this.link = this.props.data.link;
    this.isLastest = this.props.isLastest;
  }

  render() {
    return (
      this.renderButton()
    )
  }

  renderButton = () => {
    if (this.isLastest) {
      // Different colour
      return (
        <View style={{flex: 1, width: width / 4 - 8, padding: 4, margin: 0}}>
          <Button title={this.episode} color={Colour.GoGoAnimeRed} backgroundColor='transparent'
            onPress={this.WatchAnime}/>
        </View>
      )
    } else {
      return (
        <View style={{flex: 1, width: width / 4 - 8, padding: 4, margin: 0}}>
          <Button title={this.episode} color={Colour.GoGoAnimeOrange} backgroundColor='transparent'
            onPress={this.WatchAnime}/>
        </View>
      )
    }
  }

  WatchAnime = () => {
    // console.log(this.episode, this.link);
    if (this.episode == '??') Alert.alert('No episodes were found');
    else Actions.WatchAnime({title: 'Episode ' + this.episode, link: this.link, fromInfo: true})
  }
}

export default EpisodeCell;