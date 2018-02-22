import { StyleSheet } from 'react-native';
import { AnimeGoColour } from '../value';
import { deviceWidth, deviceHeight } from '../helper/DeviceDimensions';

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
  imageStyle: {
    margin: 16,
    height: deviceWidth * 0.618 * 0.25,
    width: deviceWidth * 0.618 * 0.25
  },
  iconViewStyle: {
    backgroundColor: AnimeGoColour,
    flexDirection: 'row',
    alignItems: 'center',
    height: 80,
    elevation: 2,
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
    justifyContent: 'center',
  }
})