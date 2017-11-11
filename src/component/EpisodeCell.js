import React, { Component } from 'react';
import { View, Button, Alert, Dimensions } from 'react-native';
import { Colour } from '../Styles';
import { Actions } from 'react-native-router-flux'; 

var width = Dimensions.get('window').width / 5 - 8;

class EpisodeCell extends React.PureComponent {
  
  constructor(props) {
    super(props);
    this.episode = this.props.data.number;
    this.link = this.props.data.link;
  }

  render() {
    return (
      <View style={{flex: 1, width: width, margin: 4}}>
        <Button title={this.episode} color={Colour.GoGoAnimeOrange} onPress={this.WatchAnime} />
      </View>
    )
  }

  WatchAnime = () => {
    // console.log(this.episode, this.link);
    if (this.episode == '??') Alert.alert('No episodes were found');
    else Actions.WatchAnime({title: this.episode, link: this.link})
  }
}

export default EpisodeCell;