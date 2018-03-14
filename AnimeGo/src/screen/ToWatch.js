import React, { Component } from 'react';
import { View, FlatList, Text, AsyncStorage, Button, ToastAndroid, Platform } from 'react-native';
import { SmartTouchable } from '../component';
import { styles } from './ToWatchStyles';
import { Actions } from 'react-native-router-flux';
import { RedColour } from '../value';

class ToWatch extends Component {
  constructor() {
    super()
    this.state = {
      data: Object.assign(global.favList)
    }
  }

  listKey = (item) => item.name; 
  render() {
    const { btnViewStyle, mainViewStyle, listStyle, textStyle } = styles;
    return (
      <View style={mainViewStyle}>
        <Button title='Remove all anime' color={RedColour} onPress={this.removeAllAnime}/>
        <FlatList style={listStyle} data={this.state.data} keyExtractor={this.listKey} renderItem={({item}) => {
          return (
            <SmartTouchable onPress={() => this.showAnimeDetail(item.link)}>
              <View style={btnViewStyle}>
                <Text style={textStyle} numberOfLines={2}>{item.name}</Text>
              </View>
            </SmartTouchable>
          )
        }} automaticallyAdjustContentInsets={false}/>
      </View>
    );
  }

  /**
   * Remove all anime from ToWatch list
   */
  removeAllAnime = () => {
    this.setState({data: []});
    global.favList = [];
    if (Platform.OS == 'android') ToastAndroid.show('All anime has been removed', ToastAndroid.SHORT);
    AsyncStorage.setItem('@Favourite', JSON.stringify([]));    
  }

  /**
   * Visit AnimeDetail page
   */
  showAnimeDetail(link) {
    Actions.AnimeDetail({title: 'Loading...', link: link});
  }

}

export {ToWatch};