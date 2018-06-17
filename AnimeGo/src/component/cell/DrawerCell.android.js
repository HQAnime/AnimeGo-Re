import React, { Component } from 'react';
import { View, Image, Text, StyleSheet } from 'react-native';
import { WoWsTouchable } from '../../component';
import { GREY } from 'react-native-material-color';
import { getTheme } from '../../constant/colour';

class DrawerCell extends Component {
  state = { colour: GREY[600] };
  render() {
    const { icon, title, ...props } = this.props; 
    const { colour } = this.state;
    const { viewStyle, textStyle } = styles;
    return (
      <WoWsTouchable {...props} useForeground onPressIn={() => this.setState({colour: getTheme()})} 
        delayPressOut={10} onPressOut={() => this.setState({colour: GREY[600]})}>
        <View style={viewStyle}>
          <Image source={icon} resizeMode='contain' style={{width: 20, height: 20, tintColor: colour}}/>
          <Text style={[textStyle, {color: colour}]}>{title}</Text>
        </View>
      </WoWsTouchable>
    )
  }
}

const styles = StyleSheet.create({
  viewStyle: {
    flexDirection: 'row',
    height: 44, paddingLeft: 16, margin: 4,
    alignItems: 'center', backgroundColor: 'white'
  },
  textStyle: {
    paddingLeft: 24, width: '100%', fontWeight: '500'
  }
})

export { DrawerCell };