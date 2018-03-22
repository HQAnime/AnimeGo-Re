import { StyleSheet } from 'react-native';
import { SecondaryColour } from '../../value';

export const styles = StyleSheet.create({
  viewStyle: {
    justifyContent: 'center',
    margin: 4, 
    padding: 4,
    height: 44,    
    flex: 1,
    backgroundColor: SecondaryColour,
    borderRadius: 22,        
  },
  textStyle: {
    color: 'white',
    fontWeight: 'bold',
    textAlign: 'center',
  }
})