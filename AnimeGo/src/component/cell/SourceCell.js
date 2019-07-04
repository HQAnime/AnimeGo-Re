import React, { Component } from 'react';
import { View, Text, Linking } from 'react-native';
import { AnimeButton } from '../../component';
import { styles } from './SourceCellStyles'
import { Actions } from 'react-native-router-flux';
import { GreyColour, BlueColour, RedColour } from '../../value';
import { scrapers } from 'source-scraper';
import { Button } from 'react-native-paper';

class SourceCell extends React.PureComponent {
  constructor(props) {
    super();
    const { name, source } = props.data;
    this.source = name;
    this.state = {name, source: ''};

    const scraper = scrapers.all.getFirstApplicable(source);
    scraper.scrap(url).then(scrap => {
      if (scrap.success) {
        console.log(scrap.data);
        this.setState({source: scrap.data});
      } else {
        this.setState({source: source});
      }
    })
  }

  render() {
    return this.renderButton();
  }

  renderButton = () => {
    const { viewStyle, textStyle } = styles;
    const { name, source } = this.state;
    if (this.source.includes('Download')) {
      return (
        <View style={viewStyle}>
          <Button mode='contained' disabled={source === ''} onPress={this.WatchAnime} color={RedColour}>
            {name}
          </Button>
          <Text style={textStyle}>Server list</Text>
        </View>
      )
    } else {
      return (
        <View style={viewStyle}>
          <Button mode='contained' disabled={source === ''} onPress={this.WatchAnime}>
            {name}
          </Button>
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