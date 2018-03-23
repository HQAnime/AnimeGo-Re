import { StyleSheet } from 'react-native';
import { BlueColour, RedColour, GreenColour, SecondaryColour } from '../value';

export const styles = StyleSheet.create({
  blueButton: {
    backgroundColor: BlueColour,
  },
  redButton: {
    backgroundColor: RedColour
  },
  goButton: {
    backgroundColor: SecondaryColour
  },
  greenButton: {
    backgroundColor: GreenColour
  },
  mainViewStyle: {
    flex: 1,
  },
  topMarginStyle: {
    marginTop: 8,
    marginBottom: 8
  },
  textStyle: {
    textAlign: 'center',
    fontSize: 24,
    fontWeight: 'bold'
  }
})