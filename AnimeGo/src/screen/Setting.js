import React, { Component } from 'react';
import { View, Text, Linking, Platform, ToastAndroid, Alert } from 'react-native';
import AsyncStorage from '@react-native-community/async-storage';
import { SmartTouchable, DrawerCell } from '../component';
import { Switch } from 'react-native-paper';
import { AnimeGoColour, Github, GoGoAnime, GooglePlay, Email, VERSION, MicrosoftStore, LastestRelease, API } from '../value';
import { styles } from './SettingStyles';
import GithubUpdate from '../helper/core/GithubUpdate';
import { List, Checkbox } from 'react-native-paper';

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
        <List.Item title='Data Saver' description='Hide all images from loading' onPress={this.updateSaver}
          right={() => <Switch value={dataSaver} onValueChange={this.updateSaver}/>} />
        <List.Item title='No DUB' description='Hide all dubbed anime if you perfer sub' onPress={this.updateDub}
          right={() => <Switch value={hideDub} onValueChange={this.updateDub}/>} />
        <List.Item title='Feedback' description='Send an email to developer' onPress={() => this.openLink(Email)}/>
        <List.Item title='Source code' description={Github} onPress={() => this.openLink(Github)}/>                              
        <List.Item title='GoGoAnime website' description={GoGoAnime} onPress={() => this.openLink(GoGoAnime)}/>  
        <List.Item title='Check for update' description={VERSION} onPress={this.checkUpdate}/>
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
      let updater = new GithubUpdate(API);
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