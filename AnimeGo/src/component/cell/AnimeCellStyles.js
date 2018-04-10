import { StyleSheet } from 'react-native';
import { BlueColour } from '../../value';

export const styles = StyleSheet.create({
  viewStyle: {
    flex: 1, height: 220,
    margin: 4, padding: 4,
    alignItems: 'center',
    justifyContent: 'flex-start',
  },
  titleStyle: {
    textAlign: 'center', 
    fontWeight: 'bold',
    fontSize: 11,
    color: 'black'
  },
  episodeStyle: {
    textAlign: 'center', 
    justifyContent: 'center',
    color: 'white', backgroundColor: BlueColour,
    padding: 2, margin: 2,
    fontSize: 12,
    height: 24, width: '70%',
    borderRadius: 12, elevation: 1
  }
})