import React, { Component } from 'react';
import { View, Text, Linking, StyleSheet } from 'react-native';
import { Actions } from 'react-native-router-flux';
import { GreyColour, ACCENT_COLOUR, RedColour } from '../../value';
import { Button } from 'react-native-paper';

class SourceCell extends React.PureComponent {
  constructor(props) {
    super();
    const { name, source } = props.data;
    this.source = name;
    this.link = source;
  }

  render() {
    return this.renderButton()
  }

  renderButton = () => {
    const { viewStyle, textStyle } = styles;
    if (this.source.includes('Download')) {
      return (
        <View style={viewStyle}>
          <Button raised color={RedColour} onPress={this.WatchAnime}>{this.source}</Button>
          <Text style={textStyle}>Server list</Text>
        </View>
      )
    } else {
      return (
        <View style={viewStyle}>
          <Button raised onPress={this.WatchAnime}>{this.source}</Button>
        </View>
      )
    }
  }

  WatchAnime = () => {
    // console.log(this.link);    
    Linking.openURL(this.link).catch(error => {console.error(error)});
  }
}

const styles = StyleSheet.create({
  viewStyle: {
    padding: 2 
  },
  textStyle: {
    paddingTop: 8,
    fontSize: 20,
    fontWeight: 'bold',
    textAlign: 'center',
    color: 'black'
  }
})

export { SourceCell };