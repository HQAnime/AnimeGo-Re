import React, { PureComponent } from 'react';
import { View, Text, Image, Linking } from 'react-native';
import { SmartTouchable } from '../../component';
import { deviceWidth, isPortrait, deviceHeight } from '../../helper/DeviceDimensions';
import { styles } from './AnimeCellStyles';
import { Actions } from 'react-native-router-flux';
import { moderateScale } from 'react-native-size-matters';

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
      <View style={{flex: 1}}>
        <SmartTouchable onPress={this.buttonPressed} onLongPress={this.showWebpage}>
          <View style={viewStyle}>
            { this.renderImage() }
            <Text numberOfLines={3} style={[titleStyle, {width: '95%'}]}>{this.data.name}</Text> 
            <Text style={episodeStyle}>{this.title}</Text>
          </View>
        </SmartTouchable>
      </View>
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

export default AnimeCell;