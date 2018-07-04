import React, { Component } from 'react';
import { ScrollView, View, Text, StatusBar, StyleSheet, DrawerLayoutAndroid } from 'react-native';
import { Router, Scene, Actions } from 'react-native-router-flux';
import { NewRelease, NewSeason, Movie, Popular, Genre, Setting, GenreInfo, WatchAnime, 
  AnimeDetail, SearchAnime, SubCategory, ToWatch, Schedule } from './screens';
import { AnimeGoColour, StatusBarColour, ScreenIndex } from './value';
import { DrawerSection, DrawerItem, Divider, ToolbarAction } from 'react-native-paper';
import { DataManager } from './core';
import { deviceWidth, deviceHeight } from './core/DeviceDimensions';

export default class App extends Component {
  async componentWillMount() {
    await DataManager.setupData();
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
            <Scene key='NewRelease' component={NewRelease} title='New Release' initial hideNavBar/>
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
        <DrawerItem icon='home' label='New Release' onPress={() => this.onChangingScreen(ScreenIndex.NewRelease)}/>
        <Divider/>
        <DrawerItem icon='new-releases' label='New Season' onPress={() => this.onChangingScreen(ScreenIndex.NewSeason)}/>
        <DrawerItem icon='timeline' label='Schedule' onPress={() => this.onChangingScreen(ScreenIndex.Schedule)}/>
        <Divider/>
        <DrawerItem icon='movie' label='Movie' onPress={() => this.onChangingScreen(ScreenIndex.Movie)}/>
        <DrawerItem icon='whatshot' label='Popular' onPress={() => this.onChangingScreen(ScreenIndex.Popular)}/>
        <DrawerItem icon='view-list' label='Genre' onPress={() => this.onChangingScreen(ScreenIndex.Genre)}/>
        <Divider/>
        <DrawerItem icon='play-arrow' label='ToWatch list' onPress={() => this.onChangingScreen(ScreenIndex.ToWatch)}/>            
        <DrawerItem icon='settings' label='Settings' onPress={() => this.onChangingScreen(ScreenIndex.Setting)}/>            
      </ScrollView>
    )
  }

  renderLeftBtn = () => {
    return <ToolbarAction icon='menu' onPress={this.onLeftBtnPressed}/>
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

const styles = StyleSheet.create({
  dividerStyle: {
    height: 0.75,
    marginBottom: 4,
    marginTop: 4
  },
  navigationStyle: {
    flex: 1, 
    backgroundColor: 'white'
  },
  drawerTitleStyle: {
    fontSize: 24,
    fontWeight: 'bold',
    marginLeft: 12,
    width: '90%',
    marginBottom: 8,
    color: 'white'
  },
  iconViewStyle: {
    backgroundColor: AnimeGoColour,
    alignItems: 'flex-start',
    justifyContent: 'flex-end',
    height: 128,
    padding: 0,
    elevation: 2
  },
  naviBarStyle: {
    backgroundColor: AnimeGoColour,
  },
  naviTitleStyle: {
    width: '90%',
  },
  buttonViewStyle: {
    height: 36, width: 36, 
    marginLeft: 12,
    alignItems: 'center',
    justifyContent: 'center'
  }
})