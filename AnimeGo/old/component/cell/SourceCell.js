import React, { Component } from 'react';
import { View, Text, Linking } from 'react-native';
import { AnimeButton } from '../../component';
import { styles } from './SourceCellStyles'
import { Actions } from 'react-native-router-flux';
import { GreyColour, BlueColour, RedColour } from '../../value';

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
          <AnimeButton title={this.source} onPress={this.WatchAnime} color={RedColour}/>
          <Text style={textStyle}>Server list</Text>
        </View>
      )
    } else {
      return (
        <View style={viewStyle}>
          <AnimeButton title={this.source} onPress={this.WatchAnime} color={BlueColour}/>
        </View>
      )
    }
  }

  WatchAnime = () => {
    // console.log(this.link);    
    Linking.openURL(this.link).catch(error => {console.error(error)});
  }
}

export default SourceCell;