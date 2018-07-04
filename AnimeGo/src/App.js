import React, { Component } from 'react';
import { View, Text, ScrollView, DrawerLayoutAndroid } from 'react-native';
import { 
  Toolbar, ToolbarAction, ToolbarContent,
  DrawerItem,
  Divider
} from 'react-native-paper';

export default class App extends Component {
  render() {
    return (
      <DrawerLayoutAndroid ref='drawer' 
        drawerPosition={DrawerLayoutAndroid.positions.Left}
        renderNavigationView={this.renderDrawer} >
        <View>
          <Toolbar>
            <ToolbarAction icon='menu' onPress={() => this.refs['drawer'].openDrawer()} />
            <ToolbarContent title='Anime Go α' />
            <ToolbarAction icon='more-vert' />
          </Toolbar>
          <Text>Hello World</Text>
        </View>
      </DrawerLayoutAndroid>
    )
  }

  /**
   * Render app drawer
   */
  renderDrawer = () => { 
    return (
      <ScrollView>
        <View>
          <Image />
        </View>
        <DrawerItem icon='home' label='Home' />
        <Divider />
        <DrawerItem icon='new-releases' label='Seasonal Anime' />
        <DrawerItem icon='timeline' label='Schedule' />
        <Divider />
        <DrawerItem icon='movie' label='Movie' />
        <DrawerItem icon='whatshot' label='Popular' />
        <DrawerItem icon='settings' label='Genre' />
        <Divider />
        <DrawerItem icon='view-list' label='ToWatch' />
        <DrawerItem icon='settings' label='Settings' />
        <Divider />
      </ScrollView>
    )
  }
}