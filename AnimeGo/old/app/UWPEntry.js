import React, { PureComponent } from 'react';
import { ScrollView, View, Text } from 'react-native';
import { Button } from 'react-native-elements';
import { styles } from './UWPEntryStyles';
import { SmartTouchable } from '../components/index';
import { Actions } from 'react-native-router-flux';
import { VERSION } from '../value';

export default class UWPEntry extends PureComponent {
  render() {
    const { blueButton, goButton, greenButton, redButton, mainViewStyle, horizontalViewStyle, textStyle, topMarginStyle } = styles;
    return (
      <ScrollView>
        <View>
          <View style={topMarginStyle}>
            <Text style={textStyle}>Anime</Text>
            <Button title='New Release' onPress={() => Actions.NewRelease()} buttonStyle={blueButton}/>
            <Button title='New Season' onPress={() => Actions.NewSeason()} buttonStyle={blueButton}/>
            <Button title='Popular' onPress={() => Actions.Popular()} buttonStyle={blueButton}/>          
            <Button title='Movie' onPress={() => Actions.Movie()} buttonStyle={blueButton}/>
            <Button title='Seach Anime' onPress={() => Actions.SearchAnime()} buttonStyle={redButton}/>
          </View>
          <View style={topMarginStyle}>
            <Text style={textStyle}>Utilities</Text>
            <Button title='Schedule' onPress={() => Actions.Schedule()} buttonStyle={greenButton}/>
            <Button title='Genre' onPress={() => Actions.Genre()} buttonStyle={goButton}/>
            <Button title='ToWatch list' onPress={() => Actions.ToWatch()} buttonStyle={redButton}/>
          </View>
          <View style={topMarginStyle}>
            <Button title='Settings' onPress={() => Actions.Setting()} buttonStyle={goButton}/>
          </View>
        </View>
      </ScrollView>
    )
  }
}