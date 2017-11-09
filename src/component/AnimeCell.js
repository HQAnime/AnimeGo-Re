import React, { Component } from 'react';
import { View, Text, Linking, Dimensions, Platform } from 'react-native'
import { Card, Button } from 'react-native-elements'

class AnimeCell extends Component {

  constructor(props) {
    super(props);
    this.state = {
      data: this.props.data,
      width: this.props.width,
    };   
  }

  render() {
    return (
      <Card image={{uri: this.state.data.thumbnail}} containerStyle={{padding: 0, margin: 0, width: this.state.width}}>
        <Text style={{marginBottom: 10}}>{this.state.data.name}</Text>
        <Button backgroundColor='#03A9F4' title={this.state.data.info}
          buttonStyle={{borderRadius: 5, marginLeft: 0, marginRight: 0, marginBottom: 0}}/>
      </Card>
      
    )
  }
}

export default AnimeCell;

