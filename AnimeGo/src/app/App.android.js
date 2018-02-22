/*
  App.js
  Created on 19 Feb 2018 
  by Yiheng Quan
*/

import React, { Component } from 'react';
import { ScrollView, View, Image, Text, StatusBar, DrawerLayoutAndroid } from 'react-native';
import { Router, Scene, Actions } from 'react-native-router-flux';
import { DrawerCell, SmartTouchable } from '../component';
import { Divider, Button, Icon } from 'react-native-elements';
import { NewRelease, NewSeason, Movie, Popular, Genre } from '../screen';
import { AnimeGoColour, StatusBarColour } from '../value';
import { styles } from './AppStyle';
import { deviceWidth, deviceHeight } from '../helper/DeviceDimensions';

export default class App extends Component {
  render() {
    const { naviBarStyle, naviTitleStyle } = styles;
    // The width for the drawer should be 61.8% of the device width
    return (
      <DrawerLayoutAndroid ref='Drawer'
        drawerWidth={deviceWidth * 0.618}
        drawerPosition={DrawerLayoutAndroid.positions.Left}
        renderNavigationView={this.renderNavigation}>
        <StatusBar backgroundColor={StatusBarColour} barStyle='light-content'/>
        <Router sceneStyle={{backgroundColor: 'white'}}>
          <Scene key='root' titleStyle={naviTitleStyle} navigationBarStyle={naviBarStyle} backTitle='Back'>
            <Scene key='NewRelease' component={NewRelease} title='New Release' headerTintColor='white' renderLeftButton={this.renderLeftBtn} initial/>
            <Scene key='NewSeason' component={NewSeason} title='New Season' renderLeftButton={this.renderLeftBtn}/>
            <Scene key='Movie' component={Movie} title='Movie' renderLeftButton={this.renderLeftBtn}/>
            <Scene key='Popular' component={Popular} title='Popular' navigationBarStyle={naviBarStyle} renderLeftButton={this.renderLeftBtn}/>
            <Scene key='Genre' component={Genre} title='Genre' navigationBarStyle={naviBarStyle} renderLeftButton={this.renderLeftBtn}/>
          </Scene>
        </Router>
      </DrawerLayoutAndroid>
    )
  }

  renderNavigation = () => {
    const { dividerStyle, navigationStyle, iconViewStyle, imageStyle } = styles;    
    return (
      <ScrollView style={navigationStyle}>
        <View style={iconViewStyle}>
          <Image source={require('../img/IconWhite.png')} style={imageStyle}/>      
        </View>       
        <DrawerCell text='New Release' onPress={() => this.onScreenChanging('NewRelease') }/>
        <DrawerCell text='New Season' onPress={() => this.onScreenChanging('NewSeason')}/>
        <Divider style={dividerStyle}/>
        <DrawerCell text='Movie' onPress={() => this.onScreenChanging('Movie')}/>
        <DrawerCell text='Popular' onPress={() => this.onScreenChanging('Popular')}/>
        <DrawerCell text='Genre' onPress={() => this.onScreenChanging('Genre')}/>
        <Divider style={dividerStyle}/>
        <DrawerCell text='About'/>        
      </ScrollView>
    )
  }

  renderLeftBtn = () => {
    const { buttonViewStyle } = styles;
    return (
      <SmartTouchable onPress={this.onLeftBtnPressed} round>
        <View style={buttonViewStyle}>
          <Icon name='menu' type='material-community' size={24} color='white'/>
        </View>
      </SmartTouchable>
    )
  }

  onLeftBtnPressed = () => {
    this.refs['Drawer'].openDrawer();
  }

  onScreenChanging(name) {
    Actions.reset(name, {headerTintColor: 'white'});
    this.refs['Drawer'].closeDrawer();
  }
}