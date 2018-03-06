import { StyleSheet } from 'react-native';
import { BlueColour } from '../../value';

export const styles = StyleSheet.create({
  viewStyle: {
    borderRadius: 4, flex: 1,
    margin: 4, padding: 2,
    elevation: 2,
    alignItems: 'center',
    justifyContent: 'center',
  },
  titleStyle: {
    textAlign: 'center', 
    fontWeight: 'bold',
    color: 'black'
  },
  episodeStyle: {
    textAlign: 'center', 
    justifyContent: 'center',
    color: 'white', backgroundColor: BlueColour,
    padding: 2, margin: 2,
    fontSize: 12,
    height: 24, width: '50%',
    borderRadius: 12, elevation: 1
  }
})