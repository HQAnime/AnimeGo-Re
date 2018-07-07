import React, { Component } from 'react';
import { View, Text, Switch, AsyncStorage, Linking, Platform, ToastAndroid, Alert } from 'react-native';
import { SmartTouchable, DrawerCell } from '../components';
import { AnimeGoColour, Github, GoGoAnime, Email, VERSION, MicrosoftStore, Release } from '../value';
import { styles } from './SettingStyles';
import GithubUpdate from '../core/GithubUpdate';
import { TouchableRipple, DrawerItem } from '../../node_modules/react-native-paper';

class Setting extends Component {
  state = {
    dataSaver: global.dataSaver,
    hideDub: global.hide_dub
  }

  render() {
    const { dataSaver, hideDub } = this.state;
    const { switchViewStyle, switchStyle, textStyle, versionStyle, dividerStyle } = styles;
    return (
      <View>
        <TouchableRipple onPress={this.updateDub}>
          <View style={switchViewStyle}>
            <Text style={textStyle}>Hide DUB</Text>
            <Switch style={switchStyle} value={hideDub} onTintColor={AnimeGoColour} thumbTintColor='white' onValueChange={this.updateDub}/>
          </View>
        </TouchableRipple>
        <DrawerItem label='Email feedback' onPress={() => this.openLink(Email)}/>
        <DrawerItem label='Source code' onPress={() => this.openLink(Github)}/>                              
        <DrawerItem label='GoGoAnime website' onPress={() => this.openLink(GoGoAnime)}/>  
        <DrawerItem label='Check for update' onPress={this.checkUpdate}/>              
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
      let updater = new GithubUpdate(Release);
      updater.checkUpdate(true);
    }
  }

  updateDub = () => {
    let newValue = !this.state.hideDub;
    global.hide_dub = newValue;
    this.setState({hideDub: newValue});
    AsyncStorage.setItem('@DUB', JSON.stringify(newValue));
  }
}

export {Setting};