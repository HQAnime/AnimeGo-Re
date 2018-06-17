/*
  App.js
  Created on 19 Feb 2018 
  by Yiheng Quan
*/

import { Navigation } from 'react-native-navigation';
import { SetupScreen } from '../screen';

SetupScreen();

Navigation.events().registerAppLaunchedListener(() => {
  Navigation.setRoot({
    root: {
      stack: {
        children: [{
          component: {
            name: 'go.new.release'
          }
        }],
        options: {
          topBar: {
            title: {text: 'AnimeGo'}
          }
        }
      }
    }
  });
});