import React, { Component } from 'react';
import { View, Text, Switch, AsyncStorage, Linking, Platform, ToastAndroid, Alert } from 'react-native';
import { SmartTouchable, DrawerCell } from '../component';
import { AnimeGoColour, Github, GoGoAnime, GooglePlay, Email, VERSION, MicrosoftStore, LastestRelease } from '../value';
import { styles } from './SettingStyles';
import GithubUpdate from '../helper/core/GithubUpdate';

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
        <DrawerCell text='Email feedback' onPress={() => this.openLink(Email)}/>
        <DrawerCell text='Source code' onPress={() => this.openLink(Github)}/>                              
        <DrawerCell text='GoGoAnime website' onPress={() => this.openLink(GoGoAnime)}/>  
        <DrawerCell text='Check for update' onPress={this.checkUpdate}/>              
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

  checkUpdate = () => {
    if (Platform.OS == 'windows') {
      Linking.openURL(MicrosoftStore);
    } else {
      // Github
      let updater = new GithubUpdate(LastestRelease);
      updater.checkUpdate();
    }
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