import { StyleSheet } from 'react-native';
import { AnimeGoColour } from '../value';
import { deviceWidth, deviceHeight } from '../core/DeviceDimensions';

export const styles = StyleSheet.create({
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