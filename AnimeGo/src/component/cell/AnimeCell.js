import React, { PureComponent } from 'react';
import { View, Text, Image } from 'react-native';
import { SmartTouchable } from '../../component';
import { deviceWidth } from '../../helper/DeviceDimensions';
import { styles } from './AnimeCellStyles';
import { Actions } from 'react-native-router-flux';

class AnimeCell extends PureComponent {

  constructor(props) {
    super();
    const { data, column } = props;
    this.data = data;
    this.flex = 1 / column;    
    this.title = data.info.replace('Released: ', '');
    this.width = deviceWidth / 2 - 16;
  }

  render() {
    const { viewStyle, textStyle } = styles;
    return (
      <SmartTouchable onPress={this.buttonPressed}>
        <View style={[viewStyle, {flex: this.flex}]}>
          { this.renderImage() }
          <Text numberOfLines={3} style={{width: this.width, textAlign: 'center', alignSelf: 'center'}}>{this.data.name}</Text> 
          <Text style={{textAlign: 'center', alignSelf: 'center'}}>{this.title}</Text>
        </View>
      </SmartTouchable>
    )
  }

  renderImage() {
    console.log(global.dataSaver);
    if (global.dataSaver) return null;
    else {
      return (
        <Image source={{uri: this.data.thumbnail}} style={{width: this.width, height: this.width, borderRadius: 4}} resizeMode='cover'/>          
      )
    }
  }

  buttonPressed = () => {
    if (this.data.link.includes('-episode-')) {
      // Only NewRelease redirects you to that new episode
      Actions.WatchAnime({title: this.title, link: this.data.link, fromInfo: false, headerTintColor: 'white'});
    } else if (this.data.link == 'Error') {
      // No anime found go back
      Actions.pop();
    } else {
      // AnimeDetail will be shown here
      Actions.AnimeDetail({title: 'Loading...', link: this.data.link, headerTintColor: 'white'})
    }
  }
}

export default AnimeCell;