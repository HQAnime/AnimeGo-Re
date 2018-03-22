/*
  App.js
  Created on 19 Feb 2018 
  by Yiheng Quan
*/

import React, { Component } from 'react';
import { View, StatusBar } from 'react-native';
import { Router, Scene } from 'react-native-router-flux';
import { NewRelease, NewSeason, Movie, Popular, Genre, Setting, GenreInfo, WatchAnime, AnimeDetail, SearchAnime, SubCategory } from '../screen';
import { StatusBarColour } from '../value';
import { styles } from './AppStyle';
import { DataManager } from '../helper/';
import UWPEntry from './UWPEntry';

export default class App extends Component {
  async componentWillMount() {
    await DataManager.setupData();
  }

  render() {
    const { naviBarStyle, naviTitleStyle } = styles;
    // The width for the drawer should be 61.8% of the device width
    return (
      <Router sceneStyle={{backgroundColor: 'white'}}>
        <Scene key='root' titleStyle={naviTitleStyle} headerTintColor='white' navigationBarStyle={naviBarStyle} backTitle='Back'>

          <Scene key='NewRelease' component={NewRelease} title='New Release' initial/>
          <Scene key='NewSeason' component={NewSeason} title='New Season'/>
          <Scene key='Movie' component={Movie} title='Movie'/>
          <Scene key='Popular' component={Popular} title='Popular'/>

          <Scene key='WatchAnime' component={WatchAnime}/>
          <Scene key='AnimeDetail' component={AnimeDetail}/>

          <Scene key='Genre' component={Genre} title='Genre'/>
          <Scene key='GenreInfo' component={GenreInfo}/>

          <Scene key='SearchAnime' component={SearchAnime}/>
          <Scene key='SubCategory' component={SubCategory}/>

          <Scene key='Setting' component={Setting} title='Settings'/>
        </Scene>
      </Router>
    )
  }
}