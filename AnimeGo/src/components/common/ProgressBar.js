import React from 'react';
import { View, ProgressBarAndroid } from 'react-native';
import { ACCENT_COLOUR } from '../../value';

const ProgressBar = () => {
  return (
    <View style={{flex: 1, justifyContent: 'center'}}>
      <ProgressBarAndroid color={ACCENT_COLOUR}/>
    </View>
  )
}

export { ProgressBar };