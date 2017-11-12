import React, { Component } from 'react';
import { View, Text, Linking, Dimensions } from 'react-native';
import { Card, Button } from 'react-native-elements';
import { Actions } from 'react-native-router-flux';
import { Colour } from '../Styles';
import { GoGoAnime } from '../Constant';

class AnimeCell extends React.PureComponent {

  constructor(props) {
    super(props);
    this.data = this.props.data;
    this.width = this.props.width;
    this.flex = this.width / Dimensions.get('window').width;
    this.title = this.data.info.replace('Released: ', '');
  }

  render() {
    return (
      <Card image={{uri: this.data.thumbnail}} imageStyle={{height: this.width * 1.45}}
        containerStyle={{padding: 0, margin: 0, flex: this.flex, justifyContent:'center'}}>
          <Text style={{marginBottom: 10, textAlign: 'center', height: 50}} numberOfLines={2}>{this.data.name}</Text>
          <Button backgroundColor={Colour.GoGoAnimeBlue} title={this.title}
            buttonStyle={{borderRadius: 15, height: 30, flex: 1}} onPress={this.buttonPressed}/>
      </Card>
    )
  }

  buttonPressed = () => {
    if (this.data.link.includes('-episode-')) {
      // Only NewRelease redirects you to that new episode
      Actions.WatchAnime({title: this.title, link: this.data.link,fromInfo: false});
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

