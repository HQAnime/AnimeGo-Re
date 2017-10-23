import React, { Component } from 'react';
import { Navigation } from 'react-native-navigation';

export default class App extends Component {
Navigation.startTabBasedApp({
  tabs: [
    {
      label: 'One', // tab label as appears under the icon in iOS (optional)
      screen: 'example.FirstTabScreen', // unique ID registered with Navigation.registerScreen
      title: 'Screen One', // title of the screen as appears in the nav bar (optional)
    },
    {
      label: 'Two',
      screen: 'example.SecondTabScreen',
      title: 'Screen Two'
    }
  ],
  tabsStyle: { // optional, add this if you want to style the tab bar beyond the defaults
    tabBarButtonColor: '#ffff00', // optional, change the color of the tab icons and text (also unselected). On Android, add this to appStyle
    tabBarSelectedButtonColor: '#ff9900', // optional, change the color of the selected tab icon and text (only selected). On Android, add this to appStyle
    tabBarBackgroundColor: '#551A8B', // optional, change the background color of the tab bar
    initialTabIndex: 1, // optional, the default selected bottom tab. Default: 0. On Android, add this to appStyle
  },
  appStyle: {
    orientation: 'portrait', // Sets a specific orientation to the entire app. Default: 'auto'. Supported values: 'auto', 'landscape', 'portrait'
    bottomTabBadgeTextColor: 'red', // Optional, change badge text color. Android only
    bottomTabBadgeBackgroundColor: 'green', // Optional, change badge background color. Android only
  },
  animationType: 'fade' // optional, add transition animation to root change: 'none', 'slide-down', 'fade'
});