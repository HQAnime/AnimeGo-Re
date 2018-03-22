import { StyleSheet } from 'react-native';
import { BlueColour } from '../../value';

export const styles = StyleSheet.create({
  viewStyle: {
    borderRadius: 4,
    margin: 4, padding: 2,
    alignItems: 'center',
    justifyContent: 'center',
  },
  titleStyle: {
    textAlign: 'center',
  },
  episodeStyle: {
    textAlign: 'center', 
    color: 'white', backgroundColor: BlueColour,
    fontSize: 12,
    height: 24, width: '50%',
    borderRadius: 12,
  }
})