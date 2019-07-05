/*
  App.js
  Created on 19 Feb 2018 
  by Yiheng Quan
*/

import React, { Component } from 'react';
import { ScrollView, View, Image, Text, StatusBar, DrawerLayoutAndroid, ToastAndroid } from 'react-native';
import { Router, Scene, Actions } from 'react-native-router-flux';
import { DrawerCell, SmartTouchable } from '../component';
import { Divider, Button, Icon } from 'react-native-elements';
import { NewRelease, NewSeason, Movie, Popular, Genre, Setting, GenreInfo, WatchAnime, AnimeDetail, SearchAnime, SubCategory, ToWatch, Schedule } from '../screen';
import { AnimeGoColour, StatusBarColour, ScreenIndex } from '../value';
import { styles } from './AppStyle';
import { DataManager } from '../helper/';
import { deviceWidth, deviceHeight } from '../helper/DeviceDimensions';
import { Drawer } from 'react-native-paper';
import AsyncStorage from '@react-native-community/async-storage';

export default class App extends Component {
  async componentWillMount() {
    await DataManager.setupData();
    let url = await AsyncStorage.getItem('main_link');
    if (url != null) {
      global.domain = url;
    }
  }

  render() {
    const { naviBarStyle, naviTitleStyle } = styles;
    // The width for the drawer should be 61.8% of the device width
    return (
      <DrawerLayoutAndroid ref='Drawer'
        drawerWidth={deviceWidth * 0.75}
        drawerPosition={DrawerLayoutAndroid.positions.Left}
        renderNavigationView={this.renderNavigation}>
        <StatusBar backgroundColor={StatusBarColour} barStyle='light-content'/>
        <Router sceneStyle={{backgroundColor: 'white'}} backAndroidHandler={this.onBackPress}>
          <Scene key='root' titleStyle={naviTitleStyle} headerTintColor='white' navigationBarStyle={naviBarStyle} backTitle='Back' renderLeftButton={this.renderLeftBtn}>
            <Scene key='NewRelease' component={NewRelease} title='New Release' initial/>
            <Scene key='NewSeason' component={NewSeason} title='New Season'/>
            <Scene key='Schedule' component={Schedule} title='Schedule'/>

            <Scene key='Movie' component={Movie} title='Movie'/>
            <Scene key='Popular' component={Popular} title='Popular'/>

            <Scene key='WatchAnime' component={WatchAnime}/>
            <Scene key='AnimeDetail' component={AnimeDetail}/>

            <Scene key='Genre' component={Genre} title='Genre'/>
            <Scene key='GenreInfo' component={GenreInfo}/>

            <Scene key='SearchAnime' component={SearchAnime} hideNavBar/>
            <Scene key='SubCategory' component={SubCategory}/>

            <Scene key='ToWatch' component={ToWatch} title='ToWatch'/>            
            <Scene key='Setting' component={Setting} title='Settings'/>
          </Scene>
        </Router>
      </DrawerLayoutAndroid>
    )
  }

  renderNavigation = () => {
    const { dividerStyle, navigationStyle, iconViewStyle, drawerTitleStyle } = styles;    
    return (
      <ScrollView style={navigationStyle}>
        <View style={iconViewStyle}>
          <Text style={drawerTitleStyle}>Anime Go</Text>
        </View>
        <Drawer.Item label='New Release' onPress={() => this.onChangingScreen(ScreenIndex.NewRelease)}/>
        <Drawer.Item label='New Season' onPress={() => this.onChangingScreen(ScreenIndex.NewSeason)}/>
        <Drawer.Item label='Schedule' onPress={() => this.onChangingScreen(ScreenIndex.Schedule)}/>
        <Divider style={dividerStyle}/>
        <Drawer.Item label='Movie' onPress={() => this.onChangingScreen(ScreenIndex.Movie)}/>
        <Drawer.Item label='Popular' onPress={() => this.onChangingScreen(ScreenIndex.Popular)}/>
        <Drawer.Item label='Genre' onPress={() => this.onChangingScreen(ScreenIndex.Genre)}/>
        <Divider style={dividerStyle}/>
        <Drawer.Item label='ToWatch list' onPress={() => this.onChangingScreen(ScreenIndex.ToWatch)}/>            
        <Drawer.Item label='Settings' onPress={() => this.onChangingScreen(ScreenIndex.Setting)}/>                
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

  onBackPress = () => {
    // Close the drawer as well
    this.refs['Drawer'].closeDrawer();
    if (Actions.state.index == 0) return false;
    else Actions.pop(); return true;
  }

  onChangingScreen(index) {
    switch (index) {
      case ScreenIndex.NewRelease:
        Actions.NewRelease(); break;
      case ScreenIndex.NewSeason:
        Actions.NewSeason(); break;
      case ScreenIndex.Movie:
        Actions.Movie(); break;
      case ScreenIndex.Popular:
        Actions.Popular(); break;
      case ScreenIndex.Genre:
        Actions.Genre(); break;   
      case ScreenIndex.Setting:
        Actions.Setting(); break;      
      case ScreenIndex.ToWatch:
        Actions.ToWatch(); break;
      case ScreenIndex.Schedule:
        Actions.Schedule(); break;
    }
    this.refs['Drawer'].closeDrawer();
  }
}