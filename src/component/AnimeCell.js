import React, { Component } from 'react';
import { View, Text, Linking, Dimensions } from 'react-native';
import { Card, Button } from 'react-native-elements';

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
      <Card image={{uri: this.state.data.thumbnail}} containerStyle={{padding: 0, margin: 0, width: this.state.width, justifyContent:'center'}}
        imageStyle={{height: this.state.width * 1.45}}>
          <Text style={{marginBottom: 10, textAlign: 'center'}} numberOfLines={2}>{this.state.data.name}</Text>
          <Button backgroundColor='#03A9F4' title={this.state.data.info.replace('Released: ', '')}
            buttonStyle={{borderRadius: 5}} onPress={() => Linking.openURL(this.state.data.link).catch(err => console.error('An error occurred', err))}/>
      </Card>
    )
  }
}

export default AnimeCell;

