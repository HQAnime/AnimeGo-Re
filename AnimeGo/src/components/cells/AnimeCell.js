import React, { PureComponent } from 'react';
import { View, Text, Image, Linking, StyleSheet } from 'react-native';
import { SmartTouchable } from '../../components';
import { TouchableRipple, Paper } from 'react-native-paper';
import { Actions } from 'react-native-router-flux';
import { moderateScale } from 'react-native-size-matters';
import { BlueColour } from '../../value';

class AnimeCell extends PureComponent {
  constructor(props) {
    super();
    const { data } = props;
    this.data = data; 
    this.title = data.info.replace('Released: ', '');
  }

  render() {
    const { viewStyle, textStyle, titleStyle, episodeStyle } = styles;
    return (
        <Paper onPress={this.buttonPressed} onLongPress={this.showWebpage}>
          <View style={viewStyle}>
            { this.renderImage() }
            <Text numberOfLines={3} style={[titleStyle, {width: '95%'}]}>{this.data.name}</Text> 
            <Text style={episodeStyle}>{this.title}</Text>
          </View>
        </Paper>
    )
  }

  renderImage() {
    if (global.dataSaver) return null;
    else {
      return (
        <Image source={{uri: this.data.thumbnail}} style={{width: moderateScale(100, 0.2), height: moderateScale(141, 0.2), borderRadius: 8}} resizeMode='cover'/>          
      )
    }
  }

  showWebpage = () => {
    Linking.openURL(this.data.link);
  }

  buttonPressed = () => {
    if (this.data.link.includes('-episode-')) {
      // Only NewRelease redirects you to that new episode
      Actions.WatchAnime({title: this.title, link: this.data.link, fromInfo: false});
    } else if (this.data.link == 'Error') {
      // No anime found go back
      Linking.openURL('https://www.google.com/search?q=' + this.data.name + ' gogoanime');
    } else {
      // AnimeDetail will be shown here
      Actions.AnimeDetail({title: 'Loading...', link: this.data.link})
    }
  }
}

const styles = StyleSheet.create({
  viewStyle: {
    flex: 1, height: 220,
    margin: 4, padding: 4,
    alignItems: 'center',
    justifyContent: 'flex-start',
  },
  titleStyle: {
    textAlign: 'center', 
    fontWeight: 'bold',
    fontSize: 11,
    color: 'black'
  },
  episodeStyle: {
    textAlign: 'center', 
    justifyContent: 'center',
    color: 'white', backgroundColor: BlueColour,
    padding: 2, margin: 2,
    fontSize: 12,
    height: 24, width: '70%',
    borderRadius: 12, elevation: 1
  }
})

export default AnimeCell;