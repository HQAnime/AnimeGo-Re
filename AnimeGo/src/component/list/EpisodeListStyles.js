import { StyleSheet } from 'react-native';
import { deviceWidth } from '../../helper/DeviceDimensions';

export const styles = StyleSheet.create({
  mainViewStyle: {
    borderRadius: 20,
    elevation: 2,
    flex: 1,
    margin: 4,
    padding: 4
  },
  titleStyle: {
    fontWeight: 'bold',
    textAlign: 'center',
    color: 'black',
    fontSize: 24,
    padding: 8
  },
  imageViewStyle: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
    margin: 4
  },
  imageStyle: {
    width: deviceWidth / 2,
    height: deviceWidth / 2
  },
  infoViewStyle: {
    justifyContent: 'space-between',
    flex: 1,
  },
  basicTextStyle: {
    textAlign: 'center',
    margin: 4
  },
  plotStyle: {
    padding: 4
  }
})