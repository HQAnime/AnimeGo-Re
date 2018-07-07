import React, { Component } from 'react';
import { View, FlatList, Text, AsyncStorage, ToastAndroid, Platform, Alert, StyleSheet } from 'react-native';
import { Actions } from 'react-native-router-flux';
import { RedColour } from '../value';
import { Button, TouchableRipple, Card, Paragraph } from 'react-native-paper';

class ToWatch extends Component {
  constructor() {
    super()
    this.state = {
      data: Object.assign(global.watch_list)
    }
  }

  listKey = (item) => item.name; 
  render() {
    const { btnViewStyle, mainViewStyle, textStyle } = styles;
    return (
      <View style={mainViewStyle}>
        <FlatList data={this.state.data} keyExtractor={this.listKey} renderItem={({item}) => {
          return (
            <Card>
              <TouchableRipple onPress={() => this.showAnimeDetail(item.link)} onLongPress={() => this.removeFromList(item)}>
                <View style={{flex: 1, padding: 8}}><Paragraph>{item.name}</Paragraph></View>
              </TouchableRipple>
            </Card>
          )
        }}/>
        <Button raised color={RedColour} onPress={this.removeAllAnime}>Remove all anime</Button>     
      </View>
    );
  }

  /**
   * Remove all anime from ToWatch list
   */
  removeAllAnime = () => {
    if (global.watch_list.length < 1) {
      Alert.alert('No anime', 'Please add some anime before removing any -_-')
    } else {
      Alert.alert('Warning', 'Do you want to remove all anime?',
        [
          {text: 'Cancel', onPress: () => console.log('No anime has been removed'), style: 'cancel'},
          {text: 'OK', onPress: () => {
            this.setState({data: []});
            global.watch_list = [];
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
          if (global.watch_list.length == 1) {
            this.setState({data: []});
            global.watch_list = [];
          } else {
            for (var i = 0; i < global.watch_list.length; i++) {
              let curr = global.watch_list[i];
              if (curr.name == item.name && curr.link == item.link) {
                // Remove this item
                global.watch_list.splice(i, 1);
                this.setState({data: global.watch_list});              
                break;
              }
            }
          }
          if (Platform.OS == 'android') ToastAndroid.show('Anime has been removed', ToastAndroid.SHORT);          
          AsyncStorage.setItem('@Favourite', JSON.stringify(global.watch_list));
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

const styles = StyleSheet.create({
  mainViewStyle: {
    flex: 1
  },
  btnViewStyle: {
    marginTop: 4, 
    height: 44,
    justifyContent: 'center'
  },
  textStyle: {
    fontWeight: 'bold',
    color: 'black'
  }
})

export { ToWatch };