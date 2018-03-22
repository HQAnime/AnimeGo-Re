import React, { PureComponent } from 'react';
import { View, Text, Button } from 'react-native';
import { SecondaryColour } from '../value';
import { SmartTouchable } from '../component/index';
import { Actions } from 'react-native-router-flux';

export default class UWPEntry extends PureComponent {
  render() {
    return (
      <View>
        <Button title='New Release' onPress={() => Actions.NewRelease()}/>
      </View>
    )
  }
}