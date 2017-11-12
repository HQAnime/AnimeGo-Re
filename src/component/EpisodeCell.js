import React, { Component } from 'react';
import { View, Button, Alert } from 'react-native';
import { Colour } from '../Styles';
import { Actions } from 'react-native-router-flux'; 

class EpisodeCell extends React.PureComponent {
  
  constructor(props) {
    super(props);
    this.episode = this.props.data.number;
    this.link = this.props.data.link;
  }

  render() {
    return (
      <View style={{flex: 0.25, padding: 0, margin: 0}}>
        <Button title={this.episode} color={Colour.GoGoAnimeOrange} 
          onPress={this.WatchAnime} style={{padding: 4}}/>
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