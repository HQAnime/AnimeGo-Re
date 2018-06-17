import React, { Component } from 'react';
import { TouchableNativeFeedback, TouchableOpacity, Platform, View} from 'react-native';

class SmartTouchable extends Component {
  render() {
    const { children, style, ...props } = this.props;
    const Touchable = Platform.OS == 'android' ? TouchableNativeFeedback : TouchableOpacity;
    return (
      <Touchable {...props}>
        <View style={style}>
          {children}
        </View>
      </Touchable>
    )
  }
}

export { SmartTouchable };