import { StyleSheet } from 'react-native';
import { ACCENT_COLOUR, RedColour, GreenColour, SecondaryColour } from '../value';

export const styles = StyleSheet.create({
  blueButton: {
    backgroundColor: ACCENT_COLOUR,
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