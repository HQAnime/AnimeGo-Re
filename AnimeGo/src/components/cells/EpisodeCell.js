import React, { Component } from 'react';
import { View, Alert, StyleSheet } from 'react-native';
import { AnimeButton } from '../../components';
import { Actions } from 'react-native-router-flux'; 
import { RedColour, SecondaryColour }  from '../../value';

class EpisodeCell extends Component {
  
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
        <AnimeButton title={this.episode} color={this.isLastest ? RedColour : SecondaryColour} onPress={this.WatchAnime}/>
      </View>
    )
  }

  WatchAnime = () => {
    // console.log(this.episode, this.link);
    if (this.episode == '??') Alert.alert('No episodes were found');
    else Actions.WatchAnime({title: 'Episode ' + this.episode, link: this.link, fromInfo: true})
  }
}

const styles = StyleSheet.create({
  viewStyle: {
    flex: 1,
    padding: 4, margin: 0
  }
})

export { EpisodeCell };