/*
  App.js
  Created on 19 Feb 2018 
  by Yiheng Quan
*/

import React, { Component } from 'react';
import { View, StatusBar, Linking } from 'react-native';
import { Icon } from 'react-native-elements';
import { Router, Scene, Actions } from 'react-native-router-flux';
import { NewRelease, NewSeason, Movie, Popular, Genre, Setting, GenreInfo, WatchAnime, AnimeDetail, SearchAnime, SubCategory, ToWatch, Schedule } from '../screen';
import { StatusBarColour, GoGoAnime, Github } from '../value';
import { styles } from './AppStyle';
import { DataManager } from '../helper/';
import UWPEntry from './UWPEntry';

export default class App extends Component {
  async componentWillMount() {
    await DataManager.setupData();
    var response = await fetch(global.domain);
    global.domain = response.headers.map.location["0"];
  }

  render() {
    const { naviBarStyle, naviTitleStyle } = styles;
    // The width for the drawer should be 61.8% of the device width
    return (
      <Router sceneStyle={{backgroundColor: 'white'}}>
        <Scene key='root' titleStyle={naviTitleStyle} headerTintColor='white' navigationBarStyle={naviBarStyle}
          renderLeftButton={this.renderLeftBtn} renderRightButton={this.homeButton}>
          <Scene key='MainEntry' component={UWPEntry} title='Anime Go' initial/>
          <Scene key='NewRelease' component={NewRelease} title='New Release'/>
          <Scene key='NewSeason' component={NewSeason} title='New Season'/>
          <Scene key='Schedule' component={Schedule} title='Schedule'/>

          <Scene key='Movie' component={Movie} title='Movie'/>
          <Scene key='Popular' component={Popular} title='Popular'/>

          <Scene key='WatchAnime' component={WatchAnime}/>
          <Scene key='AnimeDetail' component={AnimeDetail}/>

          <Scene key='Genre' component={Genre} title='Genre'/>
          <Scene key='GenreInfo' component={GenreInfo}/>

          <Scene key='SearchAnime' component={SearchAnime}/>
          <Scene key='SubCategory' component={SubCategory}/>

          <Scene key='ToWatch' component={ToWatch} title='ToWatch'/>            
          <Scene key='Setting' component={Setting} title='Settings'/>
        </Scene>
      </Router>
    )
  }

  homeButton = () => {
    if (Actions.currentScene == 'MainEntry') return (
      <Icon name="web" iconStyle={{padding: 10}} color='white' underlayColor='transparent' onPress={()=> Linking.openURL(GoGoAnime)}/>
    ) 
    return (
      <Icon name="home" iconStyle={{padding: 10}} color='white' underlayColor='transparent' onPress={()=> Actions.popTo('MainEntry')}/>
    )
  }

  renderLeftBtn = () => {
    if (Actions.currentScene == 'MainEntry') return (
      <Icon name='logo-github' type='ionicon' iconStyle={{padding: 10}} color='white' underlayColor='transparent' onPress={()=> Linking.openURL(Github)}/>
    )
    return (
      <Icon name="arrow-back" iconStyle={{padding: 10}} color='white' underlayColor='transparent' onPress={()=> Actions.pop()}/>
    )
  }
}