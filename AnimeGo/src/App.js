import React, { Component } from 'react';
import { View, Text, ScrollView, StyleSheet, DrawerLayoutAndroid } from 'react-native';
import { 
  Searchbar,
  DrawerItem, DrawerSection,
  Divider
} from 'react-native-paper';

export default class App extends Component {
  render() {
    const { mainView, searchBar } = styles
    return (
      <DrawerLayoutAndroid ref='drawer' 
        drawerPosition={DrawerLayoutAndroid.positions.Left}
        renderNavigationView={this.renderDrawer}>
        <View style={mainView}>
          <Searchbar ref='searchBar' style={searchBar} onIconPress={this.onMenuPressed} icon='menu' placeholder="Search AnimeGo"/>
        </View>
      </DrawerLayoutAndroid>
    )
  }

  /**
   * Render app drawer
   */
  renderDrawer = () => { 
    const { drawerView } = styles
    return (
      <View style={drawerView}>
        <ScrollView>
          <DrawerSection>
            <DrawerItem icon='home' label='Home'/>
            <Divider/>
            <DrawerItem icon='new-releases' label='Seasonal Anime'/>
            <DrawerItem icon='timeline' label='Schedule'/>
            <Divider/>
            <DrawerItem icon='movie' label='Movie'/>
            <DrawerItem icon='whatshot' label='Popular'/>
            <DrawerItem icon='view-list' label='Genre'/>
            <Divider/>
            <DrawerItem icon='play-arrow' label='ToWatch'/>
            <DrawerItem icon='settings' label='Settings'/>
          </DrawerSection>
        </ScrollView>
      </View>
    )
  }

  /**
   * Actions when menu button is pressed
   */
  onMenuPressed = () => {
    this.refs['drawer'].openDrawer()
  }
}

const styles = StyleSheet.create({
  mainView: {
    flex: 1,
  },
  drawerView: {
    flex: 1
  },
  searchBar: {
    borderRadius: 8, margin: 8,
    position: 'absolute'
  }
})