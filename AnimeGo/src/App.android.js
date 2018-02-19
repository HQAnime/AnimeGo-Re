/*
  App.js
  Created on 19 Feb 2018 
  by Yiheng Quan
*/

import React, { Component } from 'react';
import { deviceWidth, deviceHeight } from './helper/DeviceDimensions';
import { View, IMage, Text, DrawerLayoutAndroid } from 'react-native';

export default class App extends Component {
  render() {
    var navigationView = (
      <View style={{flex: 1, backgroundColor: '#E6B367'}}>

      </View>
    );
    // The width for the drawer should be 61.8% of the device width    
    console.log(deviceWidth);
    return (
      <DrawerLayoutAndroid
        drawerWidth={deviceWidth * 0.618}
        drawerPosition={DrawerLayoutAndroid.positions.Left}
        renderNavigationView={() => navigationView}>
        <View style={{flex: 1, alignItems: 'center'}}>
          <Text style={{margin: 10, fontSize: 15, textAlign: 'right'}}>Hello</Text>
          <Text style={{margin: 10, fontSize: 15, textAlign: 'right'}}>World</Text>
        </View>
      </DrawerLayoutAndroid>
    )
  }
}