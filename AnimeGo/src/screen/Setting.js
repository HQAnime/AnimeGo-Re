import React, { Component } from 'react';
import { View, Text, Switch, AsyncStorage, Linking, Platform, ToastAndroid } from 'react-native';
import { AdMobInterstitial } from 'react-native-admob';
import { SmartTouchable, DrawerCell } from '../component';
import { AnimeGoColour, Github, GoGoAnime, GooglePlay, Email, VERSION } from '../value';
import { styles } from './SettingStyles';

class Setting extends Component {
  state = {
    dataSaver: global.dataSaver,
  }

  render() {
    const { dataSaver } = this.state;
    const { switchViewStyle, switchStyle, textStyle, versionStyle, dividerStyle } = styles;
    return (
      <View>
        <SmartTouchable onPress={this.updateSaver}>
          <View style={switchViewStyle}>
            <Text style={textStyle}>Data saver</Text>
            <Switch style={switchStyle} value={dataSaver} onTintColor={AnimeGoColour} thumbTintColor='white' onValueChange={this.updateSaver}/>
          </View>
        </SmartTouchable>
        <DrawerCell text='Write a review' onPress={() => this.writeReview()}/>
        <DrawerCell text='Email feedback' onPress={() => this.openLink(Email)}/>
        <DrawerCell text='Support this app (Ad)' onPress={() => this.showAd()}/> 
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
        case GoGoAnime: ToastAndroid.show('This app is powered by GoGoAnime', ToastAndroid.SHORT); break;
      }      
    }
    Linking.openURL(link);
  }

  showAd() {
    // Showing an ad here
    AdMobInterstitial.setAdUnitID('ca-app-pub-5048098651344514/8615100584');
    AdMobInterstitial.setTestDevices([AdMobInterstitial.simulatorId]);
    AdMobInterstitial.requestAd().then(() => {
      AdMobInterstitial.showAd();
      if (Platform.OS == 'android') ToastAndroid.show('Thank you for your support', ToastAndroid.SHORT);
    });
  }

  writeReview() {
    switch (Platform.OS) {
      case 'android': 
        this.openLink(GooglePlay); 
      // Add more system later, HENRY!!
    }
  }

  updateSaver = () => {
    let newValue = !this.state.dataSaver;
    global.dataSaver = newValue;
    this.setState({dataSaver: newValue});
    AsyncStorage.setItem('@dataSaver', JSON.stringify(newValue));
  }
}

export {Setting};