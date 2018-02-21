/*
  App.js
  Created on 19 Feb 2018 
  by Yiheng Quan
*/

import React, { Component } from 'react';
import { ScrollView, View, Image, Text, DrawerLayoutAndroid } from 'react-native';
import { Router, Scene, Actions } from 'react-native-router-flux';
import { DrawerCell } from '../component';
import { Divider, Button } from 'react-native-elements';
import { styles } from './AppStyle';
import { deviceWidth, deviceHeight } from '../helper/DeviceDimensions';

export default class App extends Component {
  render() {
    const { dividerStyle, navigationStyle, iconViewStyle, imageStyle } = styles;
    let navigationView = (
      <ScrollView style={navigationStyle}>
        <View style={iconViewStyle}>
          <Image source={require('../img/IconLine.png')} style={imageStyle}/>      
        </View>
        <DrawerCell text='New release'/>
        <DrawerCell text='New season'/>
        <DrawerCell text='Movie'/>
        <DrawerCell text='Popular'/>
        <DrawerCell text='Genre'/>
        <Divider style={dividerStyle}/>        
        <DrawerCell text='About'/>        
      </ScrollView>
    );

    // The width for the drawer should be 61.8% of the device width
    return (
      <DrawerLayoutAndroid ref='Drawer'
        drawerWidth={deviceWidth * 0.618}
        drawerPosition={DrawerLayoutAndroid.positions.Left}
        renderNavigationView={() => navigationView}>
        <View></View>
      </DrawerLayoutAndroid>
    )
  }
}

/*
<Router sceneStyle={{backgroundColor: 'white'}}>
          <Scene key='root' headerTintColor='white' renderBackButton={this.backButton}>
            <Scene key='MainScreen' component={MainScreen} title='New release'
              titleStyle={titleStyle} navigationBarStyle={mainNavBarStyle}
              renderLeftButton={(
                <Button />
              )} backTitle='Back' initial/>
          </Scene>
        </Router>
*/