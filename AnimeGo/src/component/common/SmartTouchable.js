import React, { Component } from 'react';
import { TouchableNativeFeedback, TouchableOpacity, Platform } from 'react-native';

class SmartTouchable extends Component {
  render() {
    const { onPress, children, round } = this.props;
    if (Platform.OS == 'android') {
      return (
        <TouchableNativeFeedback onPress={onPress} background={round ? Touchable.SelectableBackgroundBorderless() : Touchable.SelectableBackground()}>
          {children}
        </TouchableNativeFeedback>
      )
    } else {
      return (
        <TouchableOpacity onPress={onPress}>
          {children}
        </TouchableOpacity>
      )
    }
  }
}

export {SmartTouchable};