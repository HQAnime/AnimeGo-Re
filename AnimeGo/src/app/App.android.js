/*
  App.js
  Created on 19 Feb 2018 
  by Yiheng Quan
*/

import { Navigation } from 'react-native-navigation';
import { setupScreen } from '../screen';
import { iconsLoaded } from '../icon';

iconsLoaded.then();
setupScreen();
Navigation.events().registerAppLaunchedListener(() => {
  Navigation.setRoot({
    root: {
      sideMenu: {
        left: {
          component: {
            name: 'go.drawer',
          }
        },
        center: {
          stack: {
            children: [{
              component: {
                id: 'NewRelease',
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
      }
    }
  });
});