import { StyleSheet } from 'react-native';
import { BlueColour } from '../value';

export const styles = StyleSheet.create({
  noAnimeStyle: {
    flex: 1,
    justifyContent: 'center'
  },
  mainViewStyle: {
    flex: 1
  },
  textStyle: {
    textAlign: 'center',
    color: BlueColour,
    fontSize: 16
  },
  cellViewStyle: {
    flex: 1,
    padding: 8
  },
  titleStyle: {
    textAlign: 'center',
    color: 'black',
    fontSize: 20
  },
  infoStyle: {
    textAlign: 'center'
  },
  timeStyle: {
    textAlign: 'center'
  }
})