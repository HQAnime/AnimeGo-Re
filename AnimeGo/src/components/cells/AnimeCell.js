import React, { PureComponent } from 'react';
import { View, Text, Image, Linking, StyleSheet } from 'react-native';
import { TouchableRipple, Paper, Card, Divider } from 'react-native-paper';
import { Actions } from 'react-native-router-flux';
import { moderateScale } from 'react-native-size-matters';
import { BlueColour, ACCENT_COLOUR, PRIMARY_COLOUR } from '../../value';

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
      <Card >
        <TouchableRipple useForeground onPress={this.onCardPressed}>
          <View style={{flexDirection: 'row'}}>
            <Image source={{uri: this.data.thumbnail}} style={{width: moderateScale(100, 0.2), height: moderateScale(140, 0.2)}} resizeMode='cover'/>
            <View style={{flex: 1, justifyContent: 'space-around'}}>
              <Text numberOfLines={2} style={titleStyle}>{this.data.name}</Text> 
              <Divider />
              <Text style={episodeStyle}>{this.title}</Text>
            </View>
          </View>
        </TouchableRipple>
      </Card> 
    )
  }

  /**
   * Push to WatchAnime or AnimeDetail
   */
  onCardPressed = () => {
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
    fontSize: 20,
    padding: 8
  },
  episodeStyle: {
    textAlign: 'center',
    justifyContent: 'center',
    color: ACCENT_COLOUR,
    fontSize: 17
  }
})

export default AnimeCell;