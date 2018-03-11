import React, { Component } from 'react';
import { View, Text, Switch, AsyncStorage, Linking, Platform, ToastAndroid, Share } from 'react-native';
import { SmartTouchable, DrawerCell } from '../component';
import { AnimeGoColour, Github, GoGoAnime, GooglePlay, Email, VERSION, MicrosoftStore } from '../value';
import { styles } from './SettingStyles';

class Setting extends Component {
  state = {
    dataSaver: global.dataSaver,
    hideDub: global.hideDub
  }

  render() {
    const { dataSaver, hideDub } = this.state;
    const { switchViewStyle, switchStyle, textStyle, versionStyle, dividerStyle } = styles;
    return (
      <View>
        <SmartTouchable onPress={this.updateSaver}>
          <View style={switchViewStyle}>
            <Text style={textStyle}>Data saver</Text>
            <Switch style={switchStyle} value={dataSaver} onTintColor={AnimeGoColour} thumbTintColor='white' onValueChange={this.updateSaver}/>
          </View>
        </SmartTouchable>
        <SmartTouchable onPress={this.updateDub}>
          <View style={switchViewStyle}>
            <Text style={textStyle}>Hide DUB</Text>
            <Switch style={switchStyle} value={hideDub} onTintColor={AnimeGoColour} thumbTintColor='white' onValueChange={this.updateDub}/>
          </View>
        </SmartTouchable>
        <DrawerCell text='Write a review' onPress={() => this.writeReview()}/>
        <DrawerCell text='Email feedback' onPress={() => this.openLink(Email)}/>
        <DrawerCell text='Source code' onPress={() => this.openLink(Github)}/>                              
        <DrawerCell text='GoGoAnime website' onPress={() => this.openLink(GoGoAnime)}/>                
        <Text style={versionStyle}>{VERSION}</Text>
      </View>
    )
  }

  openLink(link) {
    if (Platform.OS == 'android') {
      switch(link) {
        case Email: ToastAndroid.show('Thank you for your feedback', ToastAndroid.SHORT); break;
        case GoGoAnime: ToastAndroid.show('AnimeGo is powered by GoGoAnime', ToastAndroid.SHORT); break;
      }      
    }
    Linking.openURL(link);
  }

  getStoreLink = () => {
    var link = '';    
    switch (Platform.OS) {
      case 'android': link = GooglePlay; break;
      case 'windows': link = MicrosoftStore; break;
      // Add more system later, HENRY!!
    }
    return link;
  }

  writeReview() {
    this.openLink(this.getStoreLink());
  }

  updateSaver = () => {
    let newValue = !this.state.dataSaver;
    global.dataSaver = newValue;
    this.setState({dataSaver: newValue});
    AsyncStorage.setItem('@dataSaver', JSON.stringify(newValue));
  }

  updateDub = () => {
    let newValue = !this.state.hideDub;
    global.hideDub = newValue;
    this.setState({hideDub: newValue});
    AsyncStorage.setItem('@DUB', JSON.stringify(newValue));
  }
}

export {Setting};