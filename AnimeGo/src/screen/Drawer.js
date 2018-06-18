import React, { Component } from 'react';
import { ScrollView, View, Image, StyleSheet } from 'react-native';
import { DrawerCell } from '../component';
import { Divider } from 'react-native-elements';
import { Navigation } from 'react-native-navigation';
import { iconsMap } from '../icon';
import { AnimeGoColour, VERSION, navStyle } from '../value';

export default class Drawer extends Component {
  render() {
    const { imageView, image } = styles;
    return (
      <ScrollView style={{backgroundColor: 'white', width: '90%'}}>
        <View style={imageView}><Image source={require('../img/IconWhite.png')} style={image}/></View>
        <DrawerCell onPress={() => this.popToHome()} icon={iconsMap['home']} title='Home'/>
        <Divider />
        <DrawerCell icon={iconsMap['date-range']} title='New Season'/>
        <DrawerCell icon={iconsMap['schedule']} title='Schedule'/>
        <Divider />
        <DrawerCell icon={iconsMap['movie']} title='Movie'/>
        <DrawerCell icon={iconsMap['whatshot']} title='Popular'/>
        <DrawerCell onPress={() => this.pushToScreen('go.genre', 'Genre')} icon={iconsMap['view-list']} title='Genre'/>
        <Divider />
        <DrawerCell icon={iconsMap['play-arrow']} title='To-Watch'/>
        <DrawerCell onPress={() => this.pushToScreen('go.settings', 'Settings')} icon={iconsMap['settings']} title='Settings'/>
      </ScrollView>
    )
  }

  popToHome() {
    this.props.navigator.popToRoot({animated: false});
    this.props.navigator.toggleDrawer({
      side: 'left', animated: true, to: 'closed'
    });
  }

  pushToScreen(id, title) {
    this.props.navigator.push({
      screen: id,
      title: title,
      navigatorStyle: navStyle()
    });
    this.props.navigator.toggleDrawer({
      side: 'left', animated: true, to: 'closed'
    });
  }
}

const styles = StyleSheet.create({
  imageView: {
    backgroundColor: AnimeGoColour, height: 128,
    justifyContent: 'center', paddingLeft: 16
  },
  image: {
    height: 80, width: 80
  }
})