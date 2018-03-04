import React, { Component } from 'react';
import { View, Button, Alert } from 'react-native';
import { Actions } from 'react-native-router-flux'; 
import { styles } from './EpisodeCellStyles';
import { RedColour, SecondaryColour }  from '../../value';

class EpisodeCell extends React.PureComponent {
  
  constructor(props) {
    super(props);
    const { data, isLastest } = props;
    this.episode = data.number;
    this.link = data.link;
    this.isLastest = isLastest;
  }

  render() {
    return (
      this.renderButton()
    )
  }

  renderButton = () => {
    const { viewStyle } = styles;
    return (
      <View style={viewStyle}>
        <Button title={this.episode} color={this.isLastest ? RedColour : SecondaryColour} onPress={this.WatchAnime}/>
      </View>
    )
  }

  WatchAnime = () => {
    // console.log(this.episode, this.link);
    if (this.episode == '??') Alert.alert('No episodes were found');
    else Actions.WatchAnime({title: 'Episode ' + this.episode, link: this.link, fromInfo: true})
  }
}

export default EpisodeCell;