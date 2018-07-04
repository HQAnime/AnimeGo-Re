/*
  DrawerCell.js
  Created on 19 Feb 2018 
  by Yiheng Quan
  
  The template of all drawer cells 
*/

import React, { Component } from 'react';
import { View, Image, Text } from 'react-native';
import { SmartTouchable } from '../../component';
import { styles } from './DrawerCellStyle';

class DrawerCell extends Component {
  render() {
    const { textStyle, textViewStyle } = styles;
    const { text, onPress } = this.props;
    return (
      <View>
        <SmartTouchable onPress={onPress}>
          <View style={textViewStyle}>
            <Text style={textStyle}>{text}</Text>
          </View>
        </SmartTouchable>
      </View>
    )
  }
}

export {DrawerCell};