import React, { PureComponent } from 'react';
import { View, Text, Dimensions, Image } from 'react-native';
import { SmartTouchable } from '../../component';
import { deviceProtrait, deviceWidth, deviceHeight } from '../../helper/DeviceDimensions';
import { styles } from './AnimeCellStyles';
import { Actions } from 'react-native-router-flux';

class AnimeCell extends PureComponent {

  constructor(props) {
    super();
    const { data, width } = props;
    this.data = data;
    this.flex = this.width / Dimensions.get('window').width;
    this.title = data.info.replace('Released: ', '');

    if (deviceProtrait) {
      this.width = deviceWidth / 2 - 16;
      this.flex = 0.5;
    } else {
      this.width = deviceHeight / 4 - 32;
      this.flex = 0.25;
    }
  }

  render() {
    const { viewStyle, textStyle } = styles;
    return (
      <View style={[viewStyle, {flex: this.flex}]}>
        { this.renderImage }
        <View style={{justifyContent: 'space-between'}}>
          <Text numberOfLines={3} style={{width: this.width, textAlign: 'center', alignSelf: 'center'}}>{this.data.name}</Text> 
          <Text style={{textAlign: 'center', alignSelf: 'center'}}>{this.title}</Text>
        </View>
      </View>
    )
  }

  renderImage = () => {
    if (global.dataSaver) {
      return null;
    } else {
      return (
        <SmartTouchable>
          <Image source={{uri: this.data.thumbnail}} style={{width: this.width, height: this.width, borderRadius: 10}} resizeMode='cover'/>                      
        </SmartTouchable>
      )
    }
  }

  buttonPressed = () => {
    if (this.data.link.includes('-episode-')) {
      // Only NewRelease redirects you to that new episode
      Actions.WatchAnime({title: this.title, link: this.data.link, fromInfo: false});
    } else if (this.data.link == 'Error') {
      // No anime found go back
      Actions.pop();
    } else {
      // AnimeDetail will be shown here
      Actions.AnimeDetail({title: 'Loading...', link: this.data.link})
    }
  }
}

export default AnimeCell;