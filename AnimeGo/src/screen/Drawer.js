import React, { Component } from 'react';
import { ScrollView, View, Image } from 'react-native';
import { DrawerCell } from '../component';
import { Divider } from 'react-native-elements';
import { iconsMap } from '../icon';

export default class Drawer extends Component {
  render() {
    return (
      <ScrollView style={{backgroundColor: 'white'}}>
        <View><Image /></View>
        <DrawerCell icon={iconsMap['home']} title='Home'/>
        <Divider />
        <DrawerCell icon={iconsMap['new-releases']} title='New Release'/>
        <DrawerCell icon={iconsMap['date-range']} title='New Season'/>
        <DrawerCell icon={iconsMap['schedule']} title='Schedule'/>
        <Divider />
        <DrawerCell icon={iconsMap['movie']} title='Movie'/>
        <DrawerCell icon={iconsMap['whatshot']} title='Popular'/>
        <DrawerCell icon={iconsMap['view-list']} title='Genre'/>
        <Divider />
        <DrawerCell icon={iconsMap['play-arrow']} title='To-Watch'/>
        <DrawerCell icon={iconsMap['settings']} title='Settings'/>
      </ScrollView>
    )
  }
}