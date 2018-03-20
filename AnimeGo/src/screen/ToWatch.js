import React, { Component } from 'react';
import { View, FlatList, Text, AsyncStorage, Button, ToastAndroid, Platform, Alert } from 'react-native';
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
        <FlatList style={listStyle} data={this.state.data} keyExtractor={this.listKey} renderItem={({item}) => {
          return (
            <SmartTouchable onPress={() => this.showAnimeDetail(item.link)} onLongPress={() => this.removeFromList(item)}>
              <View style={btnViewStyle}>
                <Text style={textStyle} numberOfLines={2}>{item.name}</Text>
              </View>
            </SmartTouchable>
          )
        }} automaticallyAdjustContentInsets={false}/>
        <Button title='Remove all anime' color={RedColour} onPress={this.removeAllAnime}/>        
      </View>
    );
  }

  /**
   * Remove all anime from ToWatch list
   */
  removeAllAnime = () => {
    if (global.favList.length < 1) {
      Alert.alert('No anime', 'Please add some anime before removing any -_-')
    } else {
      Alert.alert('Warning', 'Do you want to remove all anime?',
        [
          {text: 'Cancel', onPress: () => console.log('No anime has been removed'), style: 'cancel'},
          {text: 'OK', onPress: () => {
            this.setState({data: []});
            global.favList = [];
            if (Platform.OS == 'android') ToastAndroid.show('All anime has been removed', ToastAndroid.SHORT);
            AsyncStorage.setItem('@Favourite', JSON.stringify([]));
          }},
        ]
      )  
    }
  }

  /**
   * Remove one entry from ToWatch list
   */
  removeFromList(item) {
    Alert.alert(item.name, 'Do you want to remove this anime from list?',
      [
        {text: 'Cancel', onPress: () => console.log('No anime has been removed'), style: 'cancel'},
        {text: 'OK', onPress: () => {
          if (global.favList.length == 1) {
            this.setState({data: []});
            global.favList = [];
          } else {
            for (var i = 0; i < global.favList.length; i++) {
              let curr = global.favList[i];
              if (curr.name == item.name && curr.link == item.link) {
                // Remove this item
                global.favList.splice(i, 1);
                this.setState({data: global.favList});              
                break;
              }
            }
          }
          if (Platform.OS == 'android') ToastAndroid.show('Anime has been removed', ToastAndroid.SHORT);          
          AsyncStorage.setItem('@Favourite', JSON.stringify(global.favList));
        }},
      ]
    )
  }

  /**
   * Visit AnimeDetail page
   */
  showAnimeDetail(link) {
    Actions.AnimeDetail({title: 'Loading...', link: link});
  }

}

export {ToWatch};