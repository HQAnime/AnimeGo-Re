import React, { Component } from 'react';
import { View, Text, Switch, AsyncStorage, Linking, Platform } from 'react-native';
import { styles } from './SettingStyles';
import { AnimeGoColour, Github, GoGoAnime, GooglePlay, Email, VERSION } from '../value';
import { SmartTouchable, DrawerCell } from '../component';

class Setting extends Component {
  state = {
    dataSaver: global.dataSaver,
  }

  render() {
    const { dataSaver } = this.state;
    const { switchViewStyle, switchStyle, textStyle, versionStyle } = styles;
    return (
      <View>
        <SmartTouchable onPress={this.updateSaver}>
          <View style={switchViewStyle}>
            <Text style={textStyle}>Data saver</Text>
            <Switch style={switchStyle} value={dataSaver} onTintColor={AnimeGoColour} thumbTintColor='white' onValueChange={this.updateSaver}/>
          </View>
        </SmartTouchable>
        <DrawerCell text='GoGoAnime website' onPress={() => this.openLink(GoGoAnime)}/>        
        <DrawerCell text='Source code' onPress={() => this.openLink(Github)}/>        
        <DrawerCell text='Write a review' onPress={() => this.writeReview()}/>
        <DrawerCell text='Email feedback' onPress={() => this.openLink(Email)}/>
        <Text style={versionStyle}>{VERSION}</Text>
      </View>
    )
  }

  openLink(link) {
    Linking.openURL(link);
  }

  writeReview() {
    switch (Platform.OS) {
      case 'android': this.openLink(GooglePlay); break;
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