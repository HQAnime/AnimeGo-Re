import React, { Component } from 'react';
import { View, Text, Linking, Platform, ToastAndroid, Alert } from 'react-native';
import AsyncStorage from '@react-native-community/async-storage';
import { SmartTouchable, DrawerCell } from '../component';
import { Switch, TextInput } from 'react-native-paper';
import { AnimeGoColour, Github, GoGoAnime, GooglePlay, Email, VERSION, MicrosoftStore, LastestRelease, API } from '../value';
import { styles } from './SettingStyles';
import GithubUpdate from '../helper/core/GithubUpdate';
import { List, Checkbox } from 'react-native-paper';
import { Actions } from 'react-native-router-flux';

class Setting extends Component {
  state = {
    dataSaver: global.dataSaver,
    hideDub: global.hideDub,
    link: global.domain
  }

  render() {
    const { dataSaver, hideDub, link } = this.state;
    const { switchViewStyle, switchStyle, textStyle, versionStyle, dividerStyle } = styles;
    return (
      <View>
        <TextInput value={link} onChangeText={(t) => this.setState({link: t})} onEndEditing={this.updateAnimeGoLink}/>
        <List.Item title='Data Saver' description='Hide all images from loading' onPress={this.updateSaver}
          right={() => <Switch value={dataSaver} onValueChange={this.updateSaver}/>} />
        <List.Item title='No DUB' description='Hide all dubbed anime if you perfer sub' onPress={this.updateDub}
          right={() => <Switch value={hideDub} onValueChange={this.updateDub}/>} />
        <List.Item title='Feedback' description='Send an email to developer' onPress={() => this.openLink(Email)}/>
        <List.Item title='Source code' description={Github} onPress={() => this.openLink(Github)}/>                              
        <List.Item title='GoGoAnime website' description={global.domain} onPress={() => this.openLink(global.domain)}/>  
        <List.Item title='Check for update' description={VERSION} onPress={this.checkUpdate}/>
      </View>
    )
  }

  updateAnimeGoLink = () => {
    const { link } = this.state;
    let regex = RegExp('http[s]?:\/\/.*\..*');
    let lower = link.toLowerCase();
    if (regex.test(lower)) {
      // Update link
      global.domain = lower;
      AsyncStorage.setItem('main_link', lower);
      Alert.alert('AnimeGo', 'Please make sure that you could access this website in your browser');
      Actions.NewRelease();
    } else {
      Alert.alert('Error', 'Please input a valid url');
    }
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