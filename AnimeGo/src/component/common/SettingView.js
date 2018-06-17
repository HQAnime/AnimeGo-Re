import React, { Component } from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { Divider } from 'react-native-elements';
import { getTheme } from '../../constant/colour';

class SettingView extends Component {
  render() {
    const { header, footer, children, ...props } = this.props;
    const { IOSViewStyle, headerStyle, footerStyle, headerAndroid } = styles;
    if (android) {
      // Header and divider
      return (
        <View>
          { header ? <Text style={[headerAndroid, {color: getTheme()}]}>{header}</Text> : null }
          { children }
          <Divider />
        </View>
      )
    } else {
      // IOS could have a footer and header is always capitalised
      return (
        <View style={IOSViewStyle}>
          { header ? <Text style={headerStyle}>{String(header).toUpperCase()}</Text> : null }
          <Divider />
          { children }
          <Divider />
          { footer ? <Text style={footerStyle}>{footer}</Text> : null }
        </View>
      )
    }
  }
}

const styles = StyleSheet.create({
  IOSViewStyle: {
    backgroundColor: '#EFEFF4'
  },
  headerStyle: {
    color: '#75757A',
    padding: 8, marginLeft: 8, 
    marginTop: 26
  },
  footerStyle: {
    color: '#75757A', fontSize: 12,
    padding: 8,
    marginLeft: 8, 
  },
  headerAndroid: {
    margin: 8, paddingTop: 8, paddingLeft: 4,
    fontSize: 13, fontWeight: '500'
  }
})

export { SettingView };