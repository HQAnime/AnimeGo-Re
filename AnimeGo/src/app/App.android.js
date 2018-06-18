/*
  App.js
  Created on 19 Feb 2018 
  by Yiheng Quan
*/

import { Navigation } from 'react-native-navigation';
import { setupScreen } from '../screen';
import { iconsLoaded } from '../icon';
import { navStyle } from '../value';

iconsLoaded.then();
setupScreen();
Navigation.startSingleScreenApp({
  screen: {
    screen: 'go.new.release',
    title: 'AnimeGo',
    navigatorStyle: navStyle()
  },
  drawer: {
    left: {
      screen: 'go.drawer'
    },
    style: {
      drawerShadow: true,
      contentOverlayColor: 'rgba(0,0,0,0.25)',
      leftDrawerWidth: 61,
    },
  },
  animationType: 'fade'
});