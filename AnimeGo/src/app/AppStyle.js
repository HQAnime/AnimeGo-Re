import { StyleSheet } from 'react-native';
import { AnimeGoColour } from '../value';
import { deviceWidth, deviceHeight } from '../helper/DeviceDimensions';

export const styles = StyleSheet.create({
  dividerStyle: {
    height: 0.75,
    backgroundColor: 'white'
  },
  navigationStyle: {
    flex: 1, 
    backgroundColor: AnimeGoColour
  },
  imageStyle: {
    margin: 16,
    height: deviceWidth * 0.618 * 0.25,
    width: deviceWidth * 0.618 * 0.25
  },
  iconViewStyle: {
    backgroundColor: 'white',
    flexDirection: 'row',
    alignItems: 'center',
    height: 80,
    elevation: 2,
  }
})