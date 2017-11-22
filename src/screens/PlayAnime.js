import React, { Component } from 'react';
import { Alert, Linking } from 'react-native';
import { Actions } from 'react-native-router-flux';
import Video from 'react-native-video'; 
import { Colour } from '../Styles';

class PlayAnime extends Component {
  componentDidMount() {
    this.player.presentFullscreenPlayer();    
  }    

  render() {
    return (
      <Video source={{uri: 'https://bjdobr10.s.llnwi.net/v1/nguyen1/anime/171122/boruto34_HD.mp4'}}   // Can be a URL or a local file.
       ref={(ref) => {
         this.player = ref
       }}                                      // Store reference
       rate={1.0}                              // 0 is paused, 1 is normal.
       volume={1.0}                            // 0 is muted, 1 is normal.
       muted={false}                           // Mutes the audio entirely.
       paused={false}                          // Pauses playback entirely.
       resizeMode="cover"                      // Fill the whole screen at aspect ratio.*
       repeat={false}                           // Repeat forever.
       playInBackground={false}                // Audio continues to play when app entering background.
       playWhenInactive={false}                // [iOS] Video continues to play when control or notification center are shown.
       ignoreSilentSwitch={"ignore"}           // [iOS] ignore | obey - When 'ignore', audio will still play with the iOS hard silent switch set to silent. When 'obey', audio will toggle with the switch. When not specified, will inherit audio settings as usual.
       onError={this.goBack}
       style={styles.backgroundVideo}/>
    );
  }

  goBack = () => {
    Alert.alert('Error', 'Video could not be played');
    Actions.pop();
  }
}

const styles = {
  backgroundVideo: {
    position: 'absolute',
    top: 0,
    left: 0,
    bottom: 0,
    right: 0,
  },
};

export { PlayAnime };