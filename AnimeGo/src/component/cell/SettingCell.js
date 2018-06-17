import React, { Component } from 'react';
import { View, Text, Image, TouchableHighlight, TouchableNativeFeedback, StyleSheet } from 'react-native';
import { Divider } from 'react-native-elements';
import { GREY } from 'react-native-material-color';

class SettingCell extends Component {
  render() {
    const { image, title, subtitle, divider, onPress, ...props } = this.props;
    const { viewIOSStyle, viewAndroidStyle, imageStyle, horizontalViewStyle, textStyle, titleStyle, subtitleStyle } = styles;
    if (!android) {
      // Icon with text
      return (
        <TouchableHighlight onPress={onPress}>
          <View style={viewIOSStyle}>
            <View style={horizontalViewStyle}>
              { image ? <Image source={image} style={imageStyle} resizeMode='contain'/> : <View style={{height: 29}}/> }
              <Text style={textStyle}>{title}</Text>
            </View>
            { divider ? <View style={{paddingLeft: image ? 53 : 9}}><Divider /></View> : null }
          </View>
        </TouchableHighlight>
      )
    } else {
      // Text with subtitle
      return (
        <TouchableNativeFeedback onPress={onPress}>
          <View>
            <View style={viewAndroidStyle}>
              <Text style={titleStyle}>{title}</Text>
              { subtitle ? <Text style={subtitleStyle}>{subtitle}</Text> : null }
            </View>
            { divider ? <Divider /> : null }
          </View>
        </TouchableNativeFeedback>
      )
    }
  }
}

const styles = StyleSheet.create({
  viewIOSStyle: {
    paddingLeft: 8, 
    backgroundColor: '#FFF',
  },
  viewAndroidStyle: {
    padding: 12
  },
  horizontalViewStyle: {
    flexDirection: 'row',
    padding: 8, 
    alignItems: 'center',
  },
  imageStyle: {
    height: 29, width: 29,
    borderRadius: 4, marginRight: 16
  },
  textStyle: {
    fontSize: 17, flex: 1, fontWeight: '500'
  },
  titleStyle: {
    color: GREY[900], 
    fontWeight: '300', fontSize: 17,
  },
  subtitleStyle: {
    fontSize: 13
  }
})

export { SettingCell };