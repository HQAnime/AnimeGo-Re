import { StyleSheet } from 'react-native';

export const styles = StyleSheet.create({
  headerViewStyle: {
    margin: 2,
  },
  textStyle: {
    fontSize: 20,
    fontWeight: 'bold',
    textAlign: 'center',
    color: 'black',
    padding: 4
  },
  adStyle: {
    padding: 8, fontSize: 12,
    textAlign: 'center'
  },
  buttonGroupStyle: {
    flexDirection: 'row', justifyContent: 'space-around', 
    flex: 1, paddingTop: 4
  },
  buttonStyle: {
    flex: 1, 
    padding: 1
  }
})