import React, { Component } from 'react';
import { View, Button, Alert, Dimensions } from 'react-native';
import { Colour } from '../Styles';
import { Actions } from 'react-native-router-flux'; 

const { width } = Dimensions.get('screen');

class EpisodeCell extends React.PureComponent {
  
  constructor(props) {
    super(props);
    this.episode = this.props.data.number;
    this.link = this.props.data.link;
  }

  render() {
    return (
      <View style={{flex: 1, width: width / 4 - 8, padding: 4, margin: 0}}>
        <Button title={this.episode} color={Colour.GoGoAnimeOrange} 
          onPress={this.WatchAnime}/>
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