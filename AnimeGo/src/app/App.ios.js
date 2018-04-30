/*
  App.js
  Created on 19 Feb 2018 
  by Yiheng Quan
*/

import React, { Component } from 'react';
import { View, StatusBar } from 'react-native';
import { Router, Scene, Actions } from 'react-native-router-flux';
import { Setting, GenreInfo, WatchAnime, AnimeDetail, SubCategory, NewRelease } from '../screen';
import { styles } from './AppStyle';
import { StatusBarColour } from '../value';
import { DataManager } from '../helper';

export default class App extends Component {
  async componentWillMount() {
    await DataManager.setupData();
  }

  render() {
    const { naviBarStyle, naviTitleStyle } = styles;    
    return (
      <Router sceneStyle={{backgroundColor: 'white'}}>
        <Scene key='root' titleStyle={naviTitleStyle} headerTintColor='white' navigationBarStyle={naviBarStyle}>
          <Scene key='New Release' component={NewRelease} title="AnimeGo"/>
          <Scene key='WatchAnime' component={WatchAnime}/>
          <Scene key='AnimeDetail' component={AnimeDetail}/>

          <Scene key='GenreInfo' component={GenreInfo}/>
          <Scene key='SubCategory' component={SubCategory}/>

          <Scene key='Setting' component={Setting} title='Settings'/>
        </Scene>
      </Router>
    )
  }

  setTab(ID) {
    this.setState({selected: ID});
  }
}