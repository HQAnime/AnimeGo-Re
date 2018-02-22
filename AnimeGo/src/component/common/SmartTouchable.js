import React, { Component } from 'react';
import { TouchableNativeFeedback, TouchableOpacity, Platform } from 'react-native';

// Only Android has native feedback
const Touchable = (Platform.OS == 'android') ? TouchableNativeFeedback : TouchableOpacity;

class SmartTouchable extends Component {
  render() {
    const { onPress, children, round } = this.props;
    return (
      <Touchable onPress={onPress} background={round ? Touchable.SelectableBackgroundBorderless() : Touchable.SelectableBackground()}>
        {children}
      </Touchable>
    )
  }
}

export {SmartTouchable};