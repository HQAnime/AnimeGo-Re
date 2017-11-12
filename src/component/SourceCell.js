import React, { Component } from 'react';
import { View, Button } from 'react-native';
import { Colour } from '../Styles';
import { Actions } from 'react-native-router-flux'; 

class SourceCell extends React.PureComponent {
  
  constructor(props) {
    super(props);
    this.animeName = this.props.data.name;
    this.link = this.props.data.source;
  }

  render() {
    return (
      <View>
        <Button title={this.props.data.name} color={Colour.GoGoAnimeOrange} onPress={this.WatchAnime} />
      </View>
    )
  }

  WatchAnime = () => {
    Actions.PlayVideo({title: this.animeName, link: this.link});
  }
}

export default SourceCell;