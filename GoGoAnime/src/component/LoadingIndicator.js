import React from 'react';
import { View, ActivityIndicator, Text } from 'react-native';
import { Colour } from '../Styles';

const LoadingIndicator = () => {
  return (
    <View>
      <ActivityIndicator color={Colour.GoGoAnimeOrange} style={styles.loadingStyle} size='large'/>
      <Text style={{textAlign: 'center'}}>Loading...</Text>
    </View>
  )
}

const styles = {
  loadingStyle: {
    padding: 10,
  },
} 

export { LoadingIndicator };